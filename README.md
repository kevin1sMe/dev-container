## 个人多终端适配的开发环境

### 快速使用
```bash
# download docker-compose
mkdir dev-container && cd dev-container && curl -OL https://raw.githubusercontent.com/kevin1sMe/dev-container/master/docker-compose.yaml

# setup docker
VOLUME="/[你的源码路径]" docker-compose up -d
```

### 特点
* **完全容器化**方案，一行命令即可，不需要手动安装任何东西。
* 基于doom-emacs，让你使用vim一样去使用一个强大的命令行编辑器。喜欢命令行的你，或许会爱上它！
  * 详情见：[doomemacs](https://github.com/doomemacs/doomemacs)
* 基于VS Code远程开发环境
  * 修改了一些ssh配置方便你VS Code远程使用。
* 使用了zsh并且选择了一个美观的主题：**powerlevel10k/powerlevel10k**

---

### 其它说明
* 复用了主机的docker服务，你可以在容器内执行docker命令。
* 使用-v挂载主机的源代码目录到容器内，防止你的修改因容器异常结束或不当的行为导致数据丢失。
* 替换了源为国内的清华源：**mirrors.tuna.tsinghua.edu.cn**

---

### 附带工具

#### 编程语言 & 工具
* golang1.18
* python3
* gcc/g++ 9.4
* clang/gdb/cmake/git/subversion

#### 其它工具
* mux screen 
* bash-completion shellcheck  
* tree 
* glances htop iftop iotop bmon dstat nethogs iptraf
* jq 

