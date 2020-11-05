extends Control

onready var radial = $"radial/radial"
onready var position_label = $"position/label"

onready var tile_anchor = $"tile"
onready var tile_prev = $"tile/tile_view_prev"
onready var tile_current = $"tile/tile_view_current"
onready var tile_next = $"tile/tile_view_next"
onready var type_prev = $"tile/tile_type_prev"
onready var type_next = $"tile/tile_type_next"

var icons = preload("res://scenes/ui/icons/icons.gd").new()

func update_position(x, y):
	self.position_label.set_text("[" + str(x) + ", " + str(y) + "]")

func set_tile_prev(tile, rotation):
	self.tile_prev.set_tile(tile, rotation)

func set_tile_current(tile, rotation):
	self.tile_current.set_tile(tile, rotation)

func set_tile_next(tile, rotation):
	self.tile_next.set_tile(tile, rotation)

func set_type_prev(tile, rotation):
	self.type_prev.set_tile(tile, rotation)

func set_type_next(tile, rotation):
	self.type_next.set_tile(tile, rotation)

func toggle_radial():
	if self.radial.is_visible():
		self.hide_radial()
		self.tile_anchor.show()
	else:
		self.show_radial()
		self.tile_anchor.hide()

func show_radial():
	self.radial.show_menu()

func hide_radial():
	self.radial.hide_menu()

func is_panel_open():
	if self.radial.is_visible():
		return true

	return false