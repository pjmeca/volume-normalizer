#!/bin/bash

echo "Starting rsgain..."

/usr/bin/rsgain easy -m MAX -p no_album /mnt
# -m MAX: use max number of threads
# -p no_album: disable album tags

echo "Job finished."
echo "Sleeping until next run."
