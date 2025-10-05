#!/bin/bash

sudo emerge -a tftp-hpa

sudo rc-update add in.tftpd default
sudo rc-service in.tftpd start

sudo cp -rv in.tftpd /etc/conf.d/
