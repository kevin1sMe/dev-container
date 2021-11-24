FROM ubuntu:20.04

USER root
WORKDIR /root

ENV HOME /root


# ----------------------------
# 设置源
RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list

# 添加163源
RUN sed -i '1i\deb http://mirrors.163.com/ubuntu/ focal main restricted universe multiverse' /etc/apt/sources.list
RUN sed -i '1i\deb http://mirrors.163.com/ubuntu/ focal-security main restricted universe multiverse'  /etc/apt/sources.list
RUN sed -i '1i\deb http://mirrors.163.com/ubuntu/ focal-updates main restricted universe multiverse'  /etc/apt/sources.list
RUN sed -i '1i\deb http://mirrors.163.com/ubuntu/ focal-backports main restricted universe multiverse' /etc/apt/sources.list
# ----------------------------

# 拷贝时区
COPY localtime /etc/localtime

# ---------------------------
# install essential softwares
RUN apt-get update -y && apt-get upgrade -y\
 && DEBIAN_FRONTEND=noninteractive apt-get install -y wget curl gcc g++ cmake automake autoconf libtool\
 openssh-server python3 python3-pip git sudo tmux screen locales gdb clang openssl\
 bash-completion unzip shellcheck subversion zsh vim tree
# ---------------------------


# ---------------------------



# ----------------------------
# vim插件及配置等
RUN git clone --depth=1 https://github.com/kevin1sMe/myvim.git $HOME/.vim && mv $HOME/.vim/.vimrc $HOME/
# ----------------------------



# install docker client
RUN wget -q https://download.docker.com/linux/static/stable/x86_64/docker-19.03.12.tgz &&\
  tar xzf docker*.tgz &&\
  mv docker/docker /usr/bin/ &&\
  rm -rf docker*

# --------------------------------------
# install oh-my-zsh
# 推荐换这个主题： powerlevel10k/powerlevel10k
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装powerlevel10k主题
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# --------------------------------------


# -------------- doom emacs  ------------------
# 安装emacs依赖
RUN DEBIAN_FRONTEND=noninteractive apt build-dep emacs -yq

# 安装其它依赖
# ripgrep ripgrep is a line-oriented search tool that recursively searches your current directory for a regex pattern
# fd-find  7.3.0+ (improves file indexing performance for some commands)
# vterm 插件依赖
# jansson json相关插件依赖
RUN apt install libjansson-dev ripgrep fd-find libvterm-dev -yq

# 下载并编译emacs
RUN wget http://mirrors.ustc.edu.cn/gnu/emacs/emacs-27.1.tar.xz \
    && tar xvf emacs-27.1.tar.xz  \
    && cd emacs-27.1  \
    && ./configure --with-json \
    && make -j16 \
    && make install \
    && rm -rf ~/emacs-27.1*

# 下载doom-emacs
RUN git clone --depth 1 http://github.com/hlissner/doom-emacs ~/.emacs.d

# 安装doom
RUN YES=1 ~/.emacs.d/bin/doom install

# 拷贝预定义好的doom-emacs的插件配置
COPY doom-init.el /root/.doom.d/init.el

# 配置 config.el
RUN echo "(after! doom-themes\n  (remove-hook 'doom-load-theme-hook #'doom-themes-treemacs-config))" >> /root/.doom.d/config.el
RUN echo "(package! protobuf-mode)" >> /root/.doom.d/packages.el


# 执行doom sync去安装相关插件
RUN ~/.emacs.d/bin/doom sync
# --------------------------------------




# ---------------------------
# install go
RUN wget -q https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go*.tar.gz && rm -rf go*
# install gopls
#ENV PATH=/usr/local/bin/go:$PATH
#RUN go get golang.org/x/tools/gopls@latest
# ---------------------------



# ---------------------------
# install kubectl & helm
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl &&\
  chmod +x /usr/local/bin/kubectl &&\
  kubectl completion bash > /etc/bash_completion.d/kubectl &&\
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
# ---------------------------


# ---------------------------
# setup ssh
RUN echo 'PermitRootLogin yes\n\
PasswordAuthentication yes\n\
PermitEmptyPasswords yes\n\
ChallengeResponseAuthentication no\n\
X11Forwarding yes\n\
PrintMotd no\n\
AcceptEnv LANG LC_*\n\
Port 7822\n\
Subsystem       sftp    /usr/lib/openssh/sftp-server' > /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd &&\
  passwd -d root
# ---------------------------


# ---------------------------
# config locales & TERM
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && /usr/sbin/locale-gen &&\
  echo 'export TERM="xterm-256color"' >> /etc/bash.bashrc
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
# ---------------------------

# 拷贝 tmux 配置
COPY tmux/.tmux.conf /root/.tmux.conf


COPY setup.sh /root/

# config git
COPY .gitconfig /root/.gitconfig

# 这句话好像不起作用
ENV SHELL=/usr/bin/zsh
# zsh配置
COPY zsh/.zshrc /root/.zshrc
RUN chsh -s /usr/bin/zsh

# launch sshd
CMD ["/usr/sbin/sshd", "-D"]
