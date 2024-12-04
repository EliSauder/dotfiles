!/bin/sh

if ! which hyprctl hyprlock jq touch pidof; then
    exit 1
elif pidof hyprlock; then
    exit 0
fi

touch ~/.hyprlock.lock
hyprctl activeworkspace -j | jq '.id' > ~/.hyprlock.lock
hyprctl dispatch workspace $(( $(hyprctl workspaces -j | jq '[.[].id] | max') + 1 ));
hyprlock

if [ "$(cat ~/.hyprlock.lock | grep -c "^[0-9]*$")" -eq 1 ]; then
    hyprctl dispatch workspace "$(cat ~/.hyprlock.lock | xargs)"
fi
rm ~/.hyprlock.lock
