#!/bin/sh

echo "Starting rsgain..."

if [ -s ~/.config/rsgain/presets/user_preset.ini ]; then
    preset=user_preset
else
    preset=no_album
fi

/usr/bin/rsgain easy -m MAX -p $preset /mnt
# -m MAX: use max number of threads
# -p no_album: disable album tags

echo "Job finished."
echo "Sleeping until next run."
