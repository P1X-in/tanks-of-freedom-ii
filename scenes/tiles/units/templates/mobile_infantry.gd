extends "res://scenes/tiles/units/unit.gd"


func has_active_ability():
	return self.active_abilities.size() > 0
	
func can_attack(unit):
	if unit != null:
		return not unit.can_fly
	return false
