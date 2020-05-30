#!/bin/sh

source /usr/share/devpi/bin/activate

[ -f /var/lib/devpi/.nodeinfo ] || devpi-init --serverdir /var/lib/devpi

exec devpi-server --serverdir /var/lib/devpi --host 0.0.0.0
