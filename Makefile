DOCKER_USERNAME ?= dazedmikey
APPLICATION_NAME ?= kasm-dcs-server
GIT_HASH ?= $(shell git log --format="%h" -n 1)

build:
	docker build --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH} -f Dockerfile .
 
push:
	docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}

build-dev:
	docker build --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}:develop -f Dockerfile .

release:
	docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}
	docker tag  ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH} ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
	docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
