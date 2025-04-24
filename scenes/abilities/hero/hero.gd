extends "res://scenes/abilities/ability.gd"

func _init():
	self.TYPE = "hero"


func get_cooldown():
    var modified_cooldown = self.cooldown
    if self.source != null and self.source.level == 3:
        modified_cooldown = max(modified_cooldown - 1, 1)

    return modified_cooldown
