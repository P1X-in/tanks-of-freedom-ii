
var templates = {
    'story' : load("res://scenes/board/logic/scripting/outcomes/story.gd"),

    'message' : load("res://scenes/board/logic/scripting/outcomes/message.gd"),
    'lock' : load("res://scenes/board/logic/scripting/outcomes/lock_hud.gd"),
    'unlock' : load("res://scenes/board/logic/scripting/outcomes/unlock_hud.gd"),
    'camera' : load("res://scenes/board/logic/scripting/outcomes/camera.gd"),
    'spawn' : load("res://scenes/board/logic/scripting/outcomes/spawn.gd"),
    'move' : load("res://scenes/board/logic/scripting/outcomes/move.gd"),
    'end_game' : load("res://scenes/board/logic/scripting/outcomes/end_game.gd"),
    'terrain_add' : load("res://scenes/board/logic/scripting/outcomes/terrain_add.gd"),
    'terrain_remove' : load("res://scenes/board/logic/scripting/outcomes/terrain_remove.gd"),
    'attack' : load("res://scenes/board/logic/scripting/outcomes/attack.gd"),
    'claim' : load("res://scenes/board/logic/scripting/outcomes/claim.gd"),
    'die' : load("res://scenes/board/logic/scripting/outcomes/die.gd"),
    'despawn' : load("res://scenes/board/logic/scripting/outcomes/despawn.gd"),
    'trigger' : load("res://scenes/board/logic/scripting/outcomes/trigger.gd"),
    'ap' : load("res://scenes/board/logic/scripting/outcomes/ap.gd"),
    'level_up' : load("res://scenes/board/logic/scripting/outcomes/level_up.gd"),
    'target_vip' : load("res://scenes/board/logic/scripting/outcomes/target_vip.gd"),
    'ban_unit' : load("res://scenes/board/logic/scripting/outcomes/ban_unit.gd"),
    'pause_ai' : load("res://scenes/board/logic/scripting/outcomes/pause_ai.gd"),
    'hero_ability' : load("res://scenes/board/logic/scripting/outcomes/hero_ability.gd"),
    'side' : load("res://scenes/board/logic/scripting/outcomes/side.gd"),
    'use_ability' : load("res://scenes/board/logic/scripting/outcomes/use_ability.gd"),
    'activate_hero' : load("res://scenes/board/logic/scripting/outcomes/activate_hero.gd"),
    'objective' : load("res://scenes/board/logic/scripting/outcomes/objective.gd"),
    'trigger_group' : load("res://scenes/board/logic/scripting/outcomes/trigger_group.gd"),

    'revive_player' : load("res://scenes/board/logic/scripting/outcomes/revive_player.gd"),
    'eliminate_player' : load("res://scenes/board/logic/scripting/outcomes/eliminate_player.gd"),
    'tether' : load("res://scenes/board/logic/scripting/outcomes/tether.gd")
}

func get_outcome(name):
    return self.templates[name].new()
    
