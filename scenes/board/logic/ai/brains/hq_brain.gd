extends "res://scenes/board/logic/ai/brains/abstract_building_brain.gd"

func _calculate_value(action, bonus, units_stats, ap):
    var value = super._calculate_value(action, bonus, units_stats, ap)
    
    value -= 20

    return value
