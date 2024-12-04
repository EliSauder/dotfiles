#!/bin/bash

if which hyprctl hyprlock jq touch; then
    # Left blank
elif pidof hyprlock; then
    exit 0
else
    exit 1
fi

touch ~/.hyprlock.lock
hyprctl activeworkspace -j | jq '.id' > ~/.hyprlock.lock
hyprctl dispatch workspace 42;
hyprlock

if [[ $(cat ~/.hyprlock.lock | grep "^[0-9]*$" | wc -l) == 1 ]]; then
    hyprctl dispatch workspace $(cat ~/.hyprlock.lock | xargs)
fi
rm ~/.hyprlock.lock
