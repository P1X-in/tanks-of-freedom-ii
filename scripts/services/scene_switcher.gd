extends Node


var intro_played = false

func main_menu():
	_switch_to("res://scenes/main_menu/main_menu.tscn")

func map_editor():
	_switch_to("res://scenes/map_editor/editor.tscn")

func board():
	_switch_to("res://scenes/board/board.tscn")

func board_multiplayer():
	_switch_to("res://scenes/board_multiplayer/board_multiplayer.tscn")

func board_online():
	_switch_to("res://scenes/board_online/board_online.tscn")

func _switch_to(path):
	MouseLayer.detach()
	return self.get_tree().change_scene_to_file(path)
