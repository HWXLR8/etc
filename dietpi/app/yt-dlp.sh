#!/bin/bash

source ../lib/common.sh

log "installing pipx"
sudo apt install pipx
log "> pipx ensurepath"
pipx ensurepath
log "installing yt-dlp"
pipx install git+https://github.com/yt-dlp/yt-dlp.git
