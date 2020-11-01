extends Node2D

export var size = 20

var tile = null

func _ready():
	$"Viewport/tile_cam/pivot/arm/lens".set_size(self.size)
	self.refresh()

func refresh():
	var texture = $"Viewport".get_texture()
	self.texture = texture

func set_tile(tile, rotation):
	if self.tile != null:
		self.clear()

	self.tile = tile
	$"Viewport/tile_cam".add_child(tile)

	var tile_rotation = Vector3(0, deg2rad(rotation), 0)
	tile.set_rotation(tile_rotation)
	self.refresh()

func clear():
	if self.tile == null:
		return

	self.tile.queue_free()
	self.tile = null
