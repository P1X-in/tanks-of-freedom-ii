extends Node

onready var mouse_layer = $"/root/MouseLayer"

func main_menu():
    self.mouse_layer.detach()
    return self.get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")

func map_editor():
    self.mouse_layer.detach()
    return self.get_tree().change_scene("res://scenes/map_editor/editor.tscn")

func board():
    self.mouse_layer.detach()
    return self.get_tree().change_scene("res://scenes/board/board.tscn")
