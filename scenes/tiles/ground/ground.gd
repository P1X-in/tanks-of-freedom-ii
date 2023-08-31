extends "res://scenes/tiles/tile.gd"

var mouse_collision

func prepare():
	if self.mouse_collision == null:
		self.mouse_collision = $"mouse_collision"

func bind_ground_for_mouse(map, tile_position):
	self.prepare()
	self.mouse_collision.map = map
	self.mouse_collision.tile_position = tile_position
