extends "res://scenes/tiles/units/unit.gd"

func disable_shadow():
    .disable_shadow()

    for child in $"mesh_anchor/mesh/rotor".get_children():
        if child is MeshInstance:
            child.cast_shadow = 0
        if child is Spatial:
            for subchild in child.get_children():
                if subchild is MeshInstance:
                    subchild.cast_shadow = 0
