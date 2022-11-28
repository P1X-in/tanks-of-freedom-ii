extends Node2D

onready var animations = $"animations"

func flash():
	self.animations.play("flash")
