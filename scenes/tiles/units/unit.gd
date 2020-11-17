extends "res://scenes/tiles/tile.gd"

export var side = "neutral"
export var material_type = "normal"

func get_dict():
    var new_dict = .get_dict()
    new_dict["side"] = self.side
    
    return new_dict
    
func set_side(new_side):
    self.side = new_side

func set_side_material(material):
    $"mesh".set_surface_material(0, material)

    var additional_mesh

    additional_mesh = self.get_node_or_null("mesh2")
    if additional_mesh != null:
        additional_mesh.set_surface_material(0, material)

    additional_mesh = self.get_node_or_null("mesh3")
    if additional_mesh != null:
        additional_mesh.set_surface_material(0, material)
