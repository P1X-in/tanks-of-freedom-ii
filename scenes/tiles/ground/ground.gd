extends "res://scenes/tiles/tile.gd"

onready var mouse_collision = $"mouse_collision"

func bind_ground_for_mouse(map, position):
    self.mouse_collision.map = map
    self.mouse_collision.position = position
