#!/usr/bin/env bash
# Merge del palette de Noctalia en ~/.config/starship.toml.
#
# Noctalia renderiza ~/.config/noctalia/templates/starship-palette.toml a
# ~/.cache/noctalia/starship-palette.toml y después llama a este hook. El bloque
# se reemplaza entre los markers, así que es idempotente y nunca duplica la
# tabla [palettes.noctalia].
#
# Este hook reemplaza al apply.sh del template builtin "starship" de Noctalia
# (que desactivé): el builtin sólo escribía los nombres de color de terminal y
# los tipo Catppuccin, y además forzaba `palette = "noctalia"` borrando la línea
# del archivo. Los estilos de los módulos de tu config usan nombres de roles
# Material (primary, on_primary, surface_variant, ...), que ese palette no
# tenía, así que el prompt salía sin color. Ahora el palette se genera con
# ambos juegos de nombres y la línea `palette = "noctalia"` queda como está.
set -euo pipefail

BEGIN="# >>> NOCTALIA STARSHIP PALETTE >>>"
END="# <<< NOCTALIA STARSHIP PALETTE <<<"
# Bloque viejo de mi primer intento, que hay que limpiar si quedó.
OLD_BEGIN="# >>> NOCTALIA MATERIAL PALETTE >>>"

config="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
rendered="${XDG_CACHE_HOME:-$HOME/.cache}/noctalia/starship-palette.toml"

[ -f "$rendered" ] || { echo "no existe el palette renderizado: $rendered" >&2; exit 1; }

grep -q '^\[palettes\.noctalia\]' "$rendered" || {
    echo "el palette renderizado no tiene [palettes.noctalia]" >&2
    exit 1
}
if grep -qE '=[[:space:]]*""' "$rendered"; then
    echo "el palette renderizado tiene colores vacíos" >&2
    exit 1
fi

mkdir -p "$(dirname "$config")"
[ -f "$config" ] || : >"$config"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

# 1. Si quedó el bloque del intento anterior (materials), se borra entero.
if grep -qF "$OLD_BEGIN" "$config"; then
    sed "/$(printf '%s' "$OLD_BEGIN" | sed 's/[][\.*^$/]/\\&/g')/,\$d" "$config" >"$tmp.2"
    mv "$tmp.2" "$config"
fi

# 2. Recorta el bloque de palette actual (va siempre al final del archivo).
if grep -qF "$BEGIN" "$config"; then
    sed "/$(printf '%s' "$BEGIN" | sed 's/[][\.*^$/]/\\&/g')/,\$d" "$config" >"$tmp"
    printf '%s\n' "$(cat "$tmp")" >"$tmp.2" && mv "$tmp.2" "$tmp"
else
    cp "$config" "$tmp"
fi

# 3. La línea `palette = "noctalia"` no se toca nunca: el apply.sh del builtin la
#    borraba y la reinserta, pero ese template está desactivado. Si algún día no
#    estuviera, avisamos en vez de insertar (una inserción con sed aquí ya rompió
#    la línea del "$schema" una vez).
if ! grep -qE '^palette[[:space:]]*=' "$config"; then
    echo "aviso: $config no tiene línea 'palette = ...'; el prompt quedará sin el palette de Noctalia" >&2
fi

{
    printf '\n%s\n' "$BEGIN"
    cat "$rendered"
    printf '%s\n' "$END"
} >>"$tmp"

mv "$tmp" "$config"
trap - EXIT
