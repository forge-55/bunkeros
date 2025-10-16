#!/bin/bash

if pgrep -x wlsunset > /dev/null; then
    echo '{"text": "󰖔", "class": "active", "tooltip": "Night mode enabled"}'
else
    echo '{"text": "󰖔", "class": "inactive", "tooltip": "Night mode disabled"}'
fi

