#!/bin/bash

sudo emerge -a tftp-hpa

sudo cp -rv in.tftpd /etc/conf.d/

sudo rc-update add in.tftpd default
sudo rc-service in.tftpd start
