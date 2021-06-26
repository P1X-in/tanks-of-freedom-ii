extends "res://scenes/tiles/tile.gd"

onready var explosion = $"explosion"

func show_explosion():
    self.explosion.explode_a_bit()
    
