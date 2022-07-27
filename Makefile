.PHONY: all

tag=latest

all:
	docker build -t dev-container:${tag} .
	docker tag dev-container:${tag} kevinlin86/dev-container:${tag}
	docker push kevinlin86/dev-container:${tag}