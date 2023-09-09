extends "res://scenes/tiles/tile.gd"

@onready var explosion = $"explosion"
@onready var smoke = $"smoke"

@export var is_smoking = false

func _ready():
	if self.is_smoking:
		self.smoke.set_emitting(true)

func show_explosion():
	self.explosion.explode_a_bit()
	
