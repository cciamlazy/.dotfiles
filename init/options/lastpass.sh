#!/usr/bin/env bash

if is_macos; then
  brew cask install lastpass
fi

# Waiting for this issue: https://github.com/chocolatey-community/chocolatey-coreteampackages/issues/1186
 if is_windows; then
   choco install -y lastpass-chrome
 fi
