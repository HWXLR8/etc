#!/bin/bash

echo 'KERNEL=="vcio", GROUP="video", MODE="0660"' | sudo tee /etc/udev/rules.d/99-vcio.rules > /dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger
