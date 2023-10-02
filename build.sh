#!/bin/bash -x

docker build -t jouve/devpi:$(poetry export --without-hashes | sed -n -e 's/devpi-server==\([^ ;]\+\).*/\1/p')-alpine$(sed -n -e 's/FROM alpine://p' Dockerfile) .
