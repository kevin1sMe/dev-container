#!/bin/bash

# go程序执行路径 
sed -i 's#export PATH=\(.*\)#export PATH=/usr/local/go/bin:\1#' ~/.zshrc

# 解除PATH注释
sed -i 's/#export PATH=/export PATH=/' ~/.zshrc


# 修改默认主题
sed -i 's#ZSH_THEME="\(.*\)"#ZSH_THEME="gallois"#' ~/.zshrc


# alias
source ~/.alias
