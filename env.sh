#!/bin/bash
#
export GO_PATH=$HOME/Projects/golang
#export GOPATH=$HOME/Projects/golang
#export GOBIN=$HOME/Projects/golang/bin
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/bin
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:$HOME/.emacs.d/bin
export HOMEBREW_NO_AUTO_UPDATE=1
