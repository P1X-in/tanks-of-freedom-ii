extends "res://scenes/abilities/hero/hero.gd"

export var named_icon = ""
export var ability_range = 0

func _init():
    self.TYPE = "hero_active"

func is_tile_applicable(_tile):
    return true
