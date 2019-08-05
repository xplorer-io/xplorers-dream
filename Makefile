
SHELL = /bin/bash
SHELLFLAGS = -ex

branch := $(shell git rev-parse --abbrev-ref HEAD)
VERSION ?= $(shell git rev-parse --short HEAD)

lint-yaml:
	yamllint cfn/*
.PHONY: lint-yaml

install-debian:
	$(info [+] Installing debian dependencies...)
	@sudo apt install awscli
.PHONY: install-debian

install-macos:
	@curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
	@unzip awscli-bundle.zip
	@sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
	@rm awscli-bundle.zip
	@rm -r awscli-bundle/
.PHONY: install-macos

deploy-dynamo:
	$(info [+] Deploying Xplorer's factory for dynamo...)
	@aws cloudformation deploy \
		--template-file cloudformation/infrastructure.yaml \
		--stack-name xplorers-factory-$(branch) \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameter-overrides \
			GithubBranch=$(branch)
