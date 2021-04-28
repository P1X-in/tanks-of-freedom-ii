
var templates = {
    'building_lost' : preload("res://scenes/board/logic/scripting/triggers/building_lost.gd"),
    'turn' : preload("res://scenes/board/logic/scripting/triggers/turn.gd"),
    'move' : preload("res://scenes/board/logic/scripting/triggers/move.gd"),
    'deploy' : preload("res://scenes/board/logic/scripting/triggers/deploy.gd")
}

func get_trigger(name):
    return self.templates[name].new()
    
