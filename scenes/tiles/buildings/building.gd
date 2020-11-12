extends "res://scenes/tiles/tile.gd"

export var side = "neutral"

func get_dict():
    var new_dict = .get_dict()
    new_dict["side"] = self.side
    
    return new_dict

func set_side(new_side):
    self.side = new_side

func set_side_material(material):
    $"mesh".set_surface_material(0, material)
