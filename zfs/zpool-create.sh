#!/bin/bash

sudo zpool create \
     -o ashift=12 \
     -O encryption=on \
     -O keylocation=prompt \
     -O keyformat=passphrase \
     -O compression=lz4 \
     -O atime=off \
     -O recordsize=1M \
     [POOL NAME] \
     mirror \
     nvme-[MODEL]_[SERIAL] \
     nvme-[MODEL]_[SERIAL] \
     mirror \
     nvme-[MODEL]_[SERIAL] \
     nvme-[MODEL]_[SERIAL]
