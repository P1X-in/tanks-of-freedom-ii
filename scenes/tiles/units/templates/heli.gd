extends "res://scenes/tiles/units/unit.gd"

var passenger = null

func disable_shadow():
    .disable_shadow()

    for child in $"mesh_anchor/mesh/rotor".get_children():
        if child is MeshInstance:
            child.cast_shadow = 0
        if child is Spatial:
            for subchild in child.get_children():
                if subchild is MeshInstance:
                    subchild.cast_shadow = 0
func get_dict():
    var new_dict = .get_dict()
    
    if self.passenger != null:
        new_dict["passenger"] = self.passenger.get_dict()

    return new_dict
