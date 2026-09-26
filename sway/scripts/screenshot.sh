#!/usr/bin/env sh
# Capturas de pantalla para swayFX.
# Uso: screenshot.sh [region|screen|window]
#   region → selección interactiva con slurp
#   screen → pantalla completa (output enfocado)
#   window → ventana enfocada
# Guarda en ~/Pictures/Screenshots/ y copia al portapapeles.

set -e

SHOTS_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SHOTS_DIR"

STAMP="$(date '+Screenshot from %Y-%m-%d %H-%M-%S.png')"
OUT="$SHOTS_DIR/$STAMP"

case "$1" in
    region)
        grim -g "$(slurp)" "$OUT"
        ;;
    screen)
        grim "$OUT"
        ;;
    window)
        grim -g "$(swaymsg -t get_tree | jq -r 'recurse(.nodes[], .floating_nodes[]) | select(.focused) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')" "$OUT"
        ;;
    *)
        echo "uso: $0 [region|screen|window]" >&2
        exit 1
        ;;
esac

# Copiar también al portapapeles
wl-copy < "$OUT"

# Notificación opcional (si notify-send está disponible)
command -v notify-send >/dev/null 2>&1 && notify-send -i "$OUT" "Captura guardada" "$STAMP"
