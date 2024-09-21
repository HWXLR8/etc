#!/bin/bash

sudo zpool create \
     -o ashift=12 \
     -O encryption=on \
     -O keylocation=prompt \
     -O keyformat=passphrase \
     [POOL NAME] \
     [MIRROR/RAIDZ1...] \
     [DEVICES]

# example ID:
# /dev/disk/by-id/ata-WDC_WD80EDAZ-11TA3A0_VGGW6UKG \    
# /dev/disk/by-id/ata-WDC_WD80EDAZ-11TA3A0_VGGX6ZPG


