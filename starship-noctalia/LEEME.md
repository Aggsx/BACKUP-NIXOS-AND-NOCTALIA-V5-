# Copia del setup de starship + palette de Noctalia

Fecha de la copia: 2026-09-27 10:47
(origen: `/home/axelordz`)

Los 5 archivos verificados idénticos a los originales (`cmp` sin diferencias).

## Qué es cada uno

| Archivo | Ruta original | Qué hace |
|---|---|---|
| `starship-palette.toml` | `~/.config/noctalia/templates/starship-palette.toml` | La **plantilla** de Noctalia. Genera la sección `[palettes.noctalia]` con `{{...}}`: 8 colores de terminal, nombres tipo Catppuccin y los **roles Material Design 3** (`primary`, `on_primary`, `surface_variant`, `tertiary`, `on_error`, `outline`…). |
| `merge-starship-palette.sh` | `~/.config/noctalia/scripts/merge-starship-palette.sh` | El **merge**. starship no puede importar un archivo externo, así que el palette tiene que vivir dentro de `starship.toml`. Este script reemplaza el bloque entre los marcadores `# >>> NOCTALIA STARSHIP PALETTE >>>` / `# <<< ... <<<` (idempotente) y nunca toca la línea `palette = "noctalia"`. |
| `noctalia-config.toml` | `~/.config/noctalia/config.toml` | La config de Noctalia. Lo relevante está en `[theme.templates.user.starship_palette]` (línea ~161): `input_path` → la plantilla, `output_path` → `~/.cache/noctalia/starship-palette.toml`, `post_hook` → el merge. Ojo: es la config **completa**, no solo ese bloque. |
| `starship.toml` | `~/.config/starship.toml` | Tu config de starship (290 líneas), con `palette = "noctalia"` en la línea 2 y el bloque del palette generado entre las líneas 211–290. **No editar a mano la zona de los marcadores**: se regenera sola. |
| `starship.fish` | `~/.config/fish/conf.d/starship.fish` | Inicializa el prompt: `starship init fish \| source` (en starship 1.22 `init` devuelve una línea que se llama a sí misma con `--print-full-init`, por eso el pipe a `source`). |

## Importante

El template **builtin** `starship` de Noctalia está **desactivado** a propósito (ya no
aparece en `builtin_ids`, línea ~136 de `noctalia-config.toml`). Su `apply.sh` te
borraba la línea `palette = "..."` y solo generaba los nombres de color de
terminal, que no incluyen los roles Material que usan los módulos — por eso el
prompt salía sin colorear. Si lo volvés a activar, se pisa con este setup.

## Cómo restaurar

```sh
mkdir -p ~/.config/noctalia/templates ~/.config/noctalia/scripts ~/.config/fish/conf.d
cp starship-palette.toml   ~/.config/noctalia/templates/
cp merge-starship-palette.sh ~/.config/noctalia/scripts/ && chmod +x ~/.config/noctalia/scripts/merge-starship-palette.sh
cp starship.toml           ~/.config/starship.toml
cp starship.fish           ~/.config/fish/conf.d/
```

Para `noctalia-config.toml` **no lo copies encima directamente**: sobreescribirías
toda la config de Noctalia. Editá a mano y pegá el bloque:

```toml
[theme.templates.user.starship_palette]
input_path  = "~/.config/noctalia/templates/starship-palette.toml"
output_path = "~/.cache/noctalia/starship-palette.toml"
post_hook   = "bash '/home/axelordz/.config/noctalia/scripts/merge-starship-palette.sh'"
```

Después: `noctalia msg config-reload` (o `templates-apply`) y abrí una terminal
nueva.

## Para diagnosticar

starship **solo** muestra los avisos de config cuando existe `STARSHIP_SESSION_KEY`
(la que define `starship init fish`). Con `starship prompt` pelado vas a ver cero
warnings aunque la config tenga errores. Para verlos:

```sh
STARSHIP_SESSION_KEY=test STARSHIP_LOG=warn starship prompt
```
