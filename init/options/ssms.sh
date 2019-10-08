#!/usr/bin/env bash

if is_windows; then
  choco install -y sql-server-management-studio
fi
