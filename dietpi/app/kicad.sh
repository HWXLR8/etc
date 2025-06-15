#!/bin/bash

source ../lib/common.sh

log "installing kicad"
sudo apt install kicad \
     kicad-footprints \
     kicad-libraries \
     kicad-packages3d \
     kicad-symbols
log "done"
