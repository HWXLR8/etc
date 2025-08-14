#!/bin/bash

sudo apt-get install \
     git \
     wget \
     flex \
     bison \
     gperf \
     python3 \
     python3-pip \
     python3-venv \
     cmake \
     ninja-build \
     ccache \
     libffi-dev \
     libssl-dev \
     dfu-util \
     libusb-1.0-0

cd $HOME/src
git clone -b v5.4.2 --recursive https://github.com/espressif/esp-idf.git
cd esp-idf
./install esp32c3

# add user to dialout
sudo usermod -aG dialout $(whoami)
