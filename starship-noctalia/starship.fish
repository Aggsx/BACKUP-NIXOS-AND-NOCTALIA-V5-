# starship como prompt de fish.
# En starship 1.22 `starship init fish` devuelve una línea que se llama a sí misma
# con --print-full-init, así que el pipe a `source` es lo correcto.
if status is-interactive
    starship init fish | source
end
