extends "res://scenes/tiles/units/unit.gd"

func disable_shadow():
    super.disable_shadow()

    for child in $"mesh_anchor/mesh/rotor".get_children():
        if child is MeshInstance3D:
            child.cast_shadow = 0
        if child is Node3D:
            for subchild in child.get_children():
                if subchild is MeshInstance3D:
                    subchild.cast_shadow = 0
