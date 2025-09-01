#!/bin/bash

sudo emerge -a tftp-hpa
sudo rc-service in.tftpd start
sudo rc-update add in.tftpd default
