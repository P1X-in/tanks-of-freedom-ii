
var templates = {
    'building_lost' : load("res://scenes/board/logic/scripting/triggers/building_lost.gd"),
    'turn' : load("res://scenes/board/logic/scripting/triggers/turn.gd"),
    'move' : load("res://scenes/board/logic/scripting/triggers/move.gd"),
    'deploy' : load("res://scenes/board/logic/scripting/triggers/deploy.gd"),
    'claim' : load("res://scenes/board/logic/scripting/triggers/claim.gd"),
    'decimate' : load("res://scenes/board/logic/scripting/triggers/decimate.gd"),
    'assasination' : load("res://scenes/board/logic/scripting/triggers/assasination.gd"),
    'attacked' : load("res://scenes/board/logic/scripting/triggers/attacked.gd"),
    'resources' : load("res://scenes/board/logic/scripting/triggers/resources.gd"),
    'ability' : load("res://scenes/board/logic/scripting/triggers/ability.gd"),
}

func get_trigger(name):
    return self.templates[name].new()
    
