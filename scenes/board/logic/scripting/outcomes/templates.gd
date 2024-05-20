
var templates = {
    'story' : preload("res://scenes/board/logic/scripting/outcomes/story.gd"),

    'activate_hero' : preload("res://scenes/board/logic/scripting/outcomes/activate_hero.gd"),
    'ap' : preload("res://scenes/board/logic/scripting/outcomes/ap.gd"),
    'attack' : preload("res://scenes/board/logic/scripting/outcomes/attack.gd"),
    'ban_unit' : preload("res://scenes/board/logic/scripting/outcomes/ban_unit.gd"),
    'camera' : preload("res://scenes/board/logic/scripting/outcomes/camera.gd"),
    'claim' : preload("res://scenes/board/logic/scripting/outcomes/claim.gd"),
    'despawn' : preload("res://scenes/board/logic/scripting/outcomes/despawn.gd"),
    'die' : preload("res://scenes/board/logic/scripting/outcomes/die.gd"),
    'eliminate_player' : preload("res://scenes/board/logic/scripting/outcomes/eliminate_player.gd"),
    'end_game' : preload("res://scenes/board/logic/scripting/outcomes/end_game.gd"),
    'hero_ability' : preload("res://scenes/board/logic/scripting/outcomes/hero_ability.gd"),
    'level_up' : preload("res://scenes/board/logic/scripting/outcomes/level_up.gd"),
    'lock' : preload("res://scenes/board/logic/scripting/outcomes/lock_hud.gd"),
    'message' : preload("res://scenes/board/logic/scripting/outcomes/message.gd"),
    'move' : preload("res://scenes/board/logic/scripting/outcomes/move.gd"),
    'objective' : preload("res://scenes/board/logic/scripting/outcomes/objective.gd"),
    'pause_ai' : preload("res://scenes/board/logic/scripting/outcomes/pause_ai.gd"),
    'revive_player' : preload("res://scenes/board/logic/scripting/outcomes/revive_player.gd"),
    'side' : preload("res://scenes/board/logic/scripting/outcomes/side.gd"),
    'spawn' : preload("res://scenes/board/logic/scripting/outcomes/spawn.gd"),
    'target_vip' : preload("res://scenes/board/logic/scripting/outcomes/target_vip.gd"),
    'terrain_add' : preload("res://scenes/board/logic/scripting/outcomes/terrain_add.gd"),
    'terrain_remove' : preload("res://scenes/board/logic/scripting/outcomes/terrain_remove.gd"),
    'tether' : preload("res://scenes/board/logic/scripting/outcomes/tether.gd"),
    'trigger' : preload("res://scenes/board/logic/scripting/outcomes/trigger.gd"),
    'trigger_group' : preload("res://scenes/board/logic/scripting/outcomes/trigger_group.gd"),
    'unlock' : preload("res://scenes/board/logic/scripting/outcomes/unlock_hud.gd"),
    'use_ability' : preload("res://scenes/board/logic/scripting/outcomes/use_ability.gd"),
}

func get_outcome(name):
    return self.templates[name].new()
    
