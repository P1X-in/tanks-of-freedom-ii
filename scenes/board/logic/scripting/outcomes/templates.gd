
var templates = {
    'story' : preload("res://scenes/board/logic/scripting/outcomes/story.gd"),

    'message' : preload("res://scenes/board/logic/scripting/outcomes/message.gd"),

    'end_game' : preload("res://scenes/board/logic/scripting/outcomes/end_game.gd"),
    'eliminate_player' : preload("res://scenes/board/logic/scripting/outcomes/eliminate_player.gd")
}

func get_outcome(name):
    return self.templates[name].new()
    
