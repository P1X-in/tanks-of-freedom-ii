
var templates = {
    'building_lost' : preload("res://scenes/board/logic/scripting/triggers/building_lost.gd"),
    'turn' : preload("res://scenes/board/logic/scripting/triggers/turn.gd"),
    'move' : preload("res://scenes/board/logic/scripting/triggers/move.gd"),
    'deploy' : preload("res://scenes/board/logic/scripting/triggers/deploy.gd"),
    'claim' : preload("res://scenes/board/logic/scripting/triggers/claim.gd"),
    'decimate' : preload("res://scenes/board/logic/scripting/triggers/decimate.gd"),
    'assasination' : preload("res://scenes/board/logic/scripting/triggers/assasination.gd"),
    'attacked' : preload("res://scenes/board/logic/scripting/triggers/attacked.gd"),
    'resources' : preload("res://scenes/board/logic/scripting/triggers/resources.gd"),
    'ability' : preload("res://scenes/board/logic/scripting/triggers/ability.gd"),
}

func get_trigger(name):
    return self.templates[name].new()
    
