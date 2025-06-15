#!/bin/bash

source ../lib/common.sh

log "cloning the project"
git clone https://github.com/trizen/youtube-viewer
cd youtube-viewer
log "installing perl deps"
sudo apt install libmodule-build-perl libio-socket-ssl-perl
log "building"
perl Build.PL
confirm "good?"
sudo ./Build installdeps
confirm "good?"
confirm "installing system-wide"
sudo ./Build install
