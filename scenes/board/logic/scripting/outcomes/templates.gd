
var templates = {
    'story' : preload("res://scenes/board/logic/scripting/outcomes/story.gd"),

    'message' : preload("res://scenes/board/logic/scripting/outcomes/message.gd"),
    'lock' : preload("res://scenes/board/logic/scripting/outcomes/lock_hud.gd"),
    'unlock' : preload("res://scenes/board/logic/scripting/outcomes/unlock_hud.gd"),
    'camera' : preload("res://scenes/board/logic/scripting/outcomes/camera.gd"),

    'end_game' : preload("res://scenes/board/logic/scripting/outcomes/end_game.gd"),
    'eliminate_player' : preload("res://scenes/board/logic/scripting/outcomes/eliminate_player.gd")
}

func get_outcome(name):
    return self.templates[name].new()
    
