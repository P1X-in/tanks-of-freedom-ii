extends Node2D

@onready var progress = $"background/progress"

func reset():
	self.progress.value = 0

func set_progress(value):
	self.progress.value = value
