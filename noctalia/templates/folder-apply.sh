#!/usr/bin/env bash
PRI="{{colors.primary.default.hex}}"
C1="${PRI:1}"
T_DIR="$HOME/.icons/Noctalia-Folders"
BRANCH="color-${C1}"

git -C "$T_DIR" checkout -q original -- .
git -C "$T_DIR" checkout -b "$BRANCH" 2>/dev/null || git -C "$T_DIR" checkout -q "$BRANCH"

# MOTOR DE COLOR ULTRA-AGRESIVO
find "$T_DIR" -name "*.svg" -type f -print0 | xargs -0 sed -i -E \
    -e "s/fill:#[0-9a-fA-F]{6}/fill:#${C1}/gI" \
    -e "s/fill=\"#[0-9a-fA-F]{6}\"/fill=\"#${C1}\"/gI" \
    -e "s/stop-color:#[0-9a-fA-F]{6}/stop-color:#${C1}/gI" \
    -e "s/stop-color=\"#[0-9a-fA-F]{6}\"/stop-color=\"#${C1}\"/gI" \
    -e "s/style=\"fill:#[0-9a-fA-F]{6}/style=\"fill:#${C1}/gI"

gtk-update-icon-cache -f -t "$T_DIR" 2>/dev/null
gsettings set org.gnome.desktop.interface icon-theme "hicolor"
sleep 0.5
gsettings set org.gnome.desktop.interface icon-theme "Noctalia-Folders"
