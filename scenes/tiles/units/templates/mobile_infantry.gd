extends "res://scenes/tiles/units/unit.gd"


func has_active_ability():
	return self.active_abilities.size() > 0
	

func can_attack(unit):
	if unit != null:
		if self.modifiers.has("attack_air"):
			return true

		return not unit.can_fly
	return false
