extends Control

var position_label

var tile_prev
var tile_current
var tile_next

var tile_arrow_l
var tile_arrow_r

func _ready():
	self.position_label = $"position/label"

	self.tile_prev = $"tile/tile_view_prev"
	self.tile_current = $"tile/tile_view_current"
	self.tile_next = $"tile/tile_view_next"
	self.tile_arrow_l = $"tile/tile_arrow_l"
	self.tile_arrow_r = $"tile/tile_arrow_r"

func update_position(x, y):
	self.position_label.set_text("[" + str(x) + ", " + str(y) + "]")

func set_tile_prev(tile, rotation):
	self.tile_prev.set_tile(tile, rotation)

func set_tile_current(tile, rotation):
	self.tile_current.set_tile(tile, rotation)

func set_tile_next(tile, rotation):
	self.tile_next.set_tile(tile, rotation)