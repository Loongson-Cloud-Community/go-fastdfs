#!/bin/bash



BIN_VERSION="go-fastdfs:${1-$(git describe  --tags `git rev-parse HEAD`)}"

if [[ ! -d src ]];then

cp -r vendor src

fi


export GO111MODULE="off"

mkdir -p src/github.com/sjqzhang/go-fastdfs
cp -rf cmd doc server main.go  src/github.com/sjqzhang/go-fastdfs


GOPATH=`pwd`  GOARCH=loong64 go test -v server/*.go

if [[ $? -ne 0 ]];then
  echo "test fail"
  exit 1
fi

#for linux
GOPATH=`pwd` GOOS=linux GOARCH=loong64 go build -o fileserver -ldflags "-w -s -X 'main.VERSION=$BIN_VERSION' -X 'main.BUILD_TIME=build_time:`date`' -X 'main.GO_VERSION=`go version`' -X 'main.GIT_VERSION=git_version:`git rev-parse HEAD`'" src/github.com/sjqzhang/go-fastdfs/main.go
