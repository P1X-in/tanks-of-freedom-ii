extends Node

func main_menu():
    return self.get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")

func map_editor():
    return self.get_tree().change_scene("res://scenes/map_editor/editor.tscn")

func board():
    return self.get_tree().change_scene("res://scenes/board/board.tscn")
