.PHONY: all

all:
	docker build -t workspace:latest .
	docker tag workspace:latest mirrors.tencent.com/red/workspace:latest
	docker push mirrors.tencent.com/red/workspace:latest