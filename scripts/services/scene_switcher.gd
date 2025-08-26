extends Node

@onready var mouse_layer := $"/root/MouseLayer"
var intro_played := false

func main_menu() -> void:
	_switch_to("res://scenes/main_menu/main_menu.tscn")

func map_editor() -> void:
	_switch_to("res://scenes/map_editor/editor.tscn")

func board() -> void:
	_switch_to("res://scenes/board/board.tscn")

func board_multiplayer() -> void:
	_switch_to("res://scenes/board_multiplayer/board_multiplayer.tscn")

func board_online() -> void:
	_switch_to("res://scenes/board_online/board_online.tscn")

func _switch_to(path):
	self.mouse_layer.detach()
	return self.get_tree().change_scene_to_file(path)
