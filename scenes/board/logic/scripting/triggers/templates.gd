
var templates = {
    'building_lost' : preload("res://scenes/board/logic/scripting/triggers/building_lost.gd"),
    'turn' : preload("res://scenes/board/logic/scripting/triggers/turn.gd")
}

func get_trigger(name):
    return self.templates[name].new()
    
