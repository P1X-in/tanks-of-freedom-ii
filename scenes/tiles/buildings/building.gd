extends "res://scenes/tiles/tile.gd"

export var side = "neutral"

func get_dict():
    var new_dict = .get_dict()
    new_dict["side"] = self.side
    
    return new_dict
