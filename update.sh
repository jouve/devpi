#!/bin/bash

exec docker run -it -v $PWD:/srv -w /srv alpine:3.10 sh -c "
set -e
apk add --no-cache gcc libffi libffi-dev musl-dev python3 python3-dev;
pip3 install --upgrade pip;
pip install certifi pipenv virtualenv virtualenv-clone;
pipenv lock
"
