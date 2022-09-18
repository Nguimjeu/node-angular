include ./.env

USER_ID ?= $(shell id -u)
GROUP_ID ?= $(shell id -g)
USERNAME =$(shell id -un)
GROUP_NAME =$(shell id -gn)
REPO ?= nguepi/node-angular-npm

ifeq ($(IS_DEV), true)
	TAG = $(TAG_VERSION)-dev
else
	TAG = $(TAG_VERSION)
endif

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--build-arg NPM_VERSION=$(NPM_VERSION) \
		--build-arg USER_ID=$(USER_ID) \
		--build-arg USERNAME=$(USERNAME) \
		--build-arg GROUP_ID=$(GROUP_ID) \
		--build-arg GROUP_NAME=$(GROUP_NAME) \
		./

build-node-user:
	docker build -t $(REPO):$(TAG) \
			--build-arg NODE_VERSION=$(NODE_VERSION) \
			--build-arg NPM_VERSION=$(NPM_VERSION) \
			--build-arg USER_ID=1000 \
			--build-arg GROUP_ID=1000 \
			./