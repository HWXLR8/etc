#!/bin/bash

source ../lib/common.sh

log "copying udev rule"
sudo cp -v 69-yubikey.rules /etc/udev/rules.d/

log "adding user to plugdev"
sudo usermod -aG plugdev $USER

log "reloading udev rules"
sudo udevadm control --reload-rules
sudo udevadm trigger

log "log out and log back in to apply group changes"
log "unplug and replug device to apply new udev policy"
