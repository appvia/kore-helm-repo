NAME=kore-helm-repo
AUTHOR ?= appvia
AUTHOR_EMAIL=lewis.marshall@appvia.io
BUILD_TIME=$(shell date '+%s')
GIT_SHA=$(shell git --no-pager describe --always --dirty)
REGISTRY=quay.io
ROOT_DIR=${PWD}
# TODO git tag or dirty
VERSION ?= v0.0.1
KUBE_NAMESPACE ?= kore-helm
SERVICE ?= ${KUBE_NAMESPACE}.svc.cluster.local
GOVERSION ?= 1.12.7
HARDWARE=$(shell uname -m)
LFLAGS ?= -X main.gitsha=${GIT_SHA} -X main.compiled=${BUILD_TIME}
PACKAGES=$(shell go list ./...)
REGISTRY=quay.io
ROOT_DIR=${PWD}

.PHONY: clean golang build-web build-web-static helm-update helm-package

default: build

golang:
	@echo "--> Go Version"
	@go version

clean:
	@echo "--> Cleaning"
	@rm -fr ./charts/* ./charts-stage/* ./bin/*

build-web: golang
	@echo "--> Compiling the project"
	@mkdir -p bin
	go build -ldflags "${LFLAGS}" -tags=jsoniter -o bin/${NAME} *.go

build-web-static: golang
	@echo "--> Compiling the static binary"
	@mkdir -p bin
	CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -tags=jsoniter -ldflags "-w ${LFLAGS}" -o bin/${NAME} *.go

helm-update:
	@echo "--> Updating Charts from Sources"
	@./hack/bin/charts update

helm-package:
	@echo "--> Packaging the charts"
	@./hack/bin/charts package
	@./hack/bin/charts createrepo

build: clean golang build-web-static helm-update helm-package
	@echo "--> Building Kore Helm Repo"

docker: clean
	@echo "--> Building the docker image"
	docker build -t ${REGISTRY}/${AUTHOR}/${NAME}:${VERSION} .
