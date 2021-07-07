extends "res://scenes/abilities/hero/hero.gd"

func _init():
    self.TYPE = "hero_passive"

func get_modified_cost(cost, _template_name):
    return cost
