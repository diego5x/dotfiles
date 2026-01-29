#!/bin/bash
# script to monitor brilho in i3blocks e.t.c.
# Copyright 2026 Diego 
# Licensed under the terms of the GNU GPL v3, or any later version.

CACHE_DIR="$HOME/.cache/brilho"

mkdir -p "$CACHE_DIR"

MONITORES=$(xrandr | grep " connected" | awk '{print $1}')

[ -z "$MONITORES" ] && exit 1

RET=$(yad \
    --title="Selecionar Monitor" \
    --list \
    --radiolist \
    --column="Sel" --column="Monitor" \
    $(for m in $MONITORES; do echo "FALSE $m"; done) \
    --height=200 --width=300)

[ -z "$RET" ] && exit 1

MONITOR=$(echo "$RET" | cut -d'|' -f2)

VAL=$(yad \
    --title="Brilho" \
    --scale \
    --min-value=0 \
    --max-value=10 \
    --value=10 \
    --step=1)

[ -z "$VAL" ] && exit 1

BRILHO=$(awk "BEGIN { printf \"%.1f\", $VAL / 10 }")

xrandr --output "$MONITOR" --brightness "$BRILHO"

echo "$BRILHO" > "$CACHE_DIR/$MONITOR"
