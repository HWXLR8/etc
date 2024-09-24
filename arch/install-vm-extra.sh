#!/bin/bash

source ../lib/common.sh

USR=$(whoami)

log "Installing VB guest additions"
sudo pacman -S \
     virtualbox-guest-utils

log "Enabling vboxservice"
sudo systemctl enable vboxservice
log "Starting vboxservice"
sudo systemctl start vboxservice
log "Adding user to vboxsf group"
sudo usermod -a -G vboxsf $USR
log "Adding VBoxClient --clipboard to .xinitrc"
append_xinit "VBoxClient --clipboard"
