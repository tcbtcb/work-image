#!/usr/bin/env bash

packages=('github.com/klauspost/asmfmt/cmd/asmfmt' 'github.com/go-delve/delve/cmd/dlv' 'github.com/kisielk/errcheck' 'github.com/davidrjenni/reftools/cmd/fillstruct' 'github.com/mdempsky/gocode' 'github.com/stamblerre/gocode' 'github.com/rogpeppe/godef' 'github.com/zmb3/gogetdoc' 'golang.org/x/tools/cmd/goimports' 'golang.org/x/lint/golint' 'golang.org/x/tools/gopls@latest' 'github.com/alecthomas/gometalinter' 'github.com/golangci/golangci-lint/cmd/golangci-lint' 'github.com/fatih/gomodifytags' 'golang.org/x/tools/cmd/gorename' 'github.com/jstemmer/gotags' 'golang.org/x/tools/cmd/guru' 'github.com/josharian/impl' 'honnef.co/go/tools/cmd/keyify' 'github.com/fatih/motion' 'github.com/koron/iferr')


for i in "${packages[@]}"
  do
    go get -v $i
  done

