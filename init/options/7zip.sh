#!/usr/bin/env bash

if is_macos; then
  brew cask install p7zip
fi

if is_ubuntu; then
  sudo apt-get install -y p7zip-full
fi

if is_windows; then
  choco install -y 7zip
fi
