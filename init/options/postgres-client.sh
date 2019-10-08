#!/usr/bin/env bash

if is_macos; then
  brew cask install psequel
fi

# if is_ubuntu; then
#   # TODO find a postgres client that's easy to install and that I like
# fi

if is_windows; then
  choco install -y pgcli
  choco install -y pgadmin4
fi