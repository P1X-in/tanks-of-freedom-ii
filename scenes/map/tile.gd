
var position = Vector2(0, 0)

var ground = preload("res://scenes/map/tile_fragment.gd").new()
var frame = preload("res://scenes/map/tile_fragment.gd").new()
var decoration = preload("res://scenes/map/tile_fragment.gd").new()
var terrain = preload("res://scenes/map/tile_fragment.gd").new()
var building = preload("res://scenes/map/tile_fragment.gd").new()
var unit = preload("res://scenes/map/tile_fragment.gd").new()

func _init(x, y):
	self.position.x = x
	self.position.y = y
