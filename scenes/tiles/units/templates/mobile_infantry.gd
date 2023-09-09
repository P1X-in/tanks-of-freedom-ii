extends "res://scenes/tiles/units/unit.gd"

func can_attack(unit):
	if unit != null:
		return not unit.can_fly
	return false
