
var tile = null

func set_tile(tile):
	if self.tile != null:
		self.clear()

	self.tile = tile

func clear():
	if self.tile == null:
		return

	self.tile.queue_free()
	self.tile = null

func is_present():
	return self.tile != null