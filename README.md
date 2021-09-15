## 个人基于终端的开发环境（完美替代IDE/vscode/goland之流)

### 如何使用本方案？

#### 使用docker-compose一键启动
请确保你的环境已经安装好docker和docker-compose。
* 克隆此项目, 并进入相应目录
  `git clone http://git.code.oa.com/kevinlin/dev-container.git`
  `cd dev-container`
* 使用docker-compose启动环境：
 `VOLUME="/YourSoureCodeDir" docker-compose up -d`

PS: 母机的`/YourSoureCodeDir`会被映射到`/root/`目录下。


#### 使用docker启动
`docker run -it -d --name dev --network host  -v /Your/SourceDir:/root/source  mirrors.tencent.com/red/workspace:latest`

* 使用-d后台运行，可以长期保持你的环境在线。
* 使用host网络，并且复用了主机的docker服务，你可以在容器内执行docker命令。
* 使用-v挂载主机的源代码目录到容器内，防止你的修改因容器异常结束或不当的行为导致数据丢失。
