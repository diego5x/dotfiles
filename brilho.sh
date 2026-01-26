#!/bin/bash

CACHE_DIR="$HOME/.cache/brilho"
SYMB="✦︎"

mkdir -p "$CACHE_DIR"

# Lista monitores conectados
MONITORES=$(xrandr | grep " connected" | awk '{print $1}')

if [ -z "$MONITORES" ]; then
    yad --error --text="Nenhum monitor detectado."
    exit 1
fi

# Seleciona monitor
MONITOR_ESCOLHIDO=$(yad \
    --title="Selecionar Monitor" \
    --form \
    --field="Monitor:CB" \
    "$(echo "$MONITORES" | sed 's/ /!/g')")

[ -z "$MONITOR_ESCOLHIDO" ] && exit 1

# Remove o "|" do yad
MONITOR_ESCOLHIDO="${MONITOR_ESCOLHIDO//|/}"

# Slider 0–10
VALOR_INT=$(yad \
    --title="Ajustar Brilho" \
    --scale \
    --text="Escolha o nível de brilho" \
    --min-value=0 \
    --max-value=10 \
    --value=10 \
    --step=1)

[ -z "$VALOR_INT" ] && exit 1

# Converte para 0.0 – 1.0
VALOR_BRILHO=$(awk "BEGIN { printf \"%.1f\", $VALOR_INT / 10 }")

xrandr --output "$MONITOR_ESCOLHIDO" --brightness "$VALOR_BRILHO"

echo "$VALOR_BRILHO" > "$CACHE_DIR/$MONITOR_ESCOLHIDO"

# Confirmação visual
yad --info --text="Monitor: $MONITOR_ESCOLHIDO\nBrilho: $VALOR_BRILHO"

# ===== SAÍDA PARA I3BLOCKS =====
for m in $MONITORES; do
    if [ -f "$CACHE_DIR/$m" ]; then
        b=$(cat "$CACHE_DIR/$m")
    else
        b="1.0"
    fi
    printf "%s %s:%s  " "$SYMB" "$m" "$b"
done

echo
