extends "res://scenes/tiles/units/unit.gd"

var passenger = null

func disable_shadow():
    .disable_shadow()

    for child in $"mesh_anchor/mesh/rotor".get_children():
        if child is MeshInstance:
            child.cast_shadow = 0
