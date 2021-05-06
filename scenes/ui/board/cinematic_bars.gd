extends Control

onready var animations = $"animations"

var is_extended = false

func show_bars():
    self.animations.play("show")
    self.is_extended = true

func hide_bars():
    self.animations.play("hide")
    self.is_extended = false
