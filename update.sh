#!/bin/bash

if ! test -w /var/run/docker.sock; then
  SUDO=sudo
else
  SUDO=
fi
$SUDO docker run -it -v $PWD:/srv -w /srv alpine:3.11 sh -c "
set -e
apk add --no-cache gcc libffi libffi-dev musl-dev python3 python3-dev
pip3 install --upgrade pip
pip install pipenv
pip freeze
pipenv lock
"
