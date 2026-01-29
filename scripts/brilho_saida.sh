#!/bin/bash

CACHE_DIR="$HOME/.cache/brilho"
SYMB="✦︎"

MONITORES=$(xrandr | grep " connected" | awk '{print $1}')

[ -z "$MONITORES" ] && exit 0

for m in $MONITORES; do
    if [ -f "$CACHE_DIR/$m" ]; then
        b=$(cat "$CACHE_DIR/$m")
    else
        b="1.0"
    fi
    printf "%s %s: %s " "$SYMB" "$m" "$b"
done

echo
