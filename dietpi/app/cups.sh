#!/bin/bash

source ../lib/common.sh

log "installing cups"
sudo apt install cups
sudo usermod -a -G lpadmin $USER
log "configure cups to accept jobs from any host"
sudo cupsctl --remote-any
log "restarting cups service"
sudo systemctl restart cups
log "you can now access the printer server from localhost:631"
