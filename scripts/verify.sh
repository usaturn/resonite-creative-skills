#!/usr/bin/env bash
set -euo pipefail

git diff --check "$(git hash-object -t tree /dev/null)" HEAD
