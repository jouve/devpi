#!/bin/sh

[ -f /var/lib/devpi/.nodeinfo ] || devpi-server --serverdir /var/lib/devpi --init

exec devpi-server --serverdir /var/lib/devpi --host 0.0.0.0

