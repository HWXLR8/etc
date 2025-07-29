#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <host>"
    exit 1
fi

HOST=$1

# This will generate a key which does not require a PIN
ssh-keygen -t ed25519-sk -O resident -O application=ssh:$HOST
