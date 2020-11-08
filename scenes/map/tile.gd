
var position = Vector2(0, 0)

var ground = preload("res://scenes/map/tile_fragment.gd").new()
var frame = preload("res://scenes/map/tile_fragment.gd").new()
var decoration = preload("res://scenes/map/tile_fragment.gd").new()
var terrain = preload("res://scenes/map/tile_fragment.gd").new()
var building = preload("res://scenes/map/tile_fragment.gd").new()
var unit = preload("res://scenes/map/tile_fragment.gd").new()

var fragments = []

func _init(x, y):
	self.position.x = x
	self.position.y = y

	self.fragments  = [
		self.ground,
		self.frame,
		self.decoration,
		self.terrain,
		self.building,
		self.unit,
	]

func has_content():
	for fragment in self.fragments:
		if fragment.is_present():
			return true
	return false

func get_dict():
	return {
		"ground" : self.ground.get_dict(),
		"frame" : self.frame.get_dict(),
		"decoration" : self.decoration.get_dict(),
		"terrain" : self.terrain.get_dict(),
		"building" : self.building.get_dict(),
		"unit" : self.unit.get_dict(),
	}

func wipe():
    self.unit.clear()
    self.building.clear()
    self.terrain.clear()
    self.decoration.clear()
    self.frame.clear()
    self.ground.clear()