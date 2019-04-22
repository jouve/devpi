#!/bin/bash

exec docker run -it -v $PWD:/srv -w /srv alpine:3.9 sh -c "
set -e
apk add --no-cache
apk add --no-cache gcc libffi libffi-dev musl-dev python3 python3-dev;
pip3 install pip==19.0.3;
pip install certifi==2019.3.9 pipenv==2018.11.26 virtualenv==16.4.3 virtualenv-clone==0.5.3;
pipenv update
"
