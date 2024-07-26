extends Node

enum MODE {KEYBOARD, GAMEPAD}

var current_mode :MODE = MODE.KEYBOARD

var atlas := load("res://assets/gui/icons/controls/tilemap_packed.png") as Texture2D

signal mode_changed()

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and current_mode != MODE.GAMEPAD:
		current_mode = MODE.GAMEPAD
		mode_changed.emit()
	elif event is InputEventKey and current_mode != MODE.KEYBOARD:
		current_mode = MODE.KEYBOARD
		mode_changed.emit()
