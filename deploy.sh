#!/bin/sh

set -e

if [ "$#" -lt 1 ] || [ -z "$GITHUB_SHA" ] || [ -z "$GITHUB_REF" ]; then
  echo 'usage: env GITHUB_SHA=<commit-hash> GITHUB_REF=<git-ref> deploy.sh <image> [...docker build args]' >&2
  exit 1
fi

if [ -n "$GITHUB_HEAD_REF" ] && [ "$GITHUB_HEAD_REF" = "refs/heads/develop" ]; then
  echo 'pull request from develop not deployed'
  exit 0
fi

img="$1"

build() {
  npm ci
  make build
}

shift

brc="$(echo "$GITHUB_REF" | sed -n 's#refs/heads/##p')"
tag="$(echo "$GITHUB_REF" | sed -n 's#refs/tags/##p')"

if [ -n "$tag" ]; then
  build
  docker build -t "${img}:${GITHUB_SHA}" "$@"
  docker tag "${img}:${GITHUB_SHA}" "${img}:${tag}"
  docker push "${img}:${tag}"
elif [ "$brc" = "develop" ]; then
  build
  docker build -t "${img}:${GITHUB_SHA}" "$@"
  docker tag "${img}:${GITHUB_SHA}" "${img}:develop"
  docker push "${img}:develop"
elif [ "$brc" = "master" ]; then
  build
  docker build -t "${img}:${GITHUB_SHA}" "$@"
  docker tag "${img}:${GITHUB_SHA}" "${img}:latest"
  docker push "${img}:latest"
else
  echo 'no action taken'
fi
