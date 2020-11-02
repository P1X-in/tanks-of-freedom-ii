
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

func get_dict():
	var new_dict = {}

	if self.tile != null:
		var rotation = self.tile.get_rotation_degrees()

		new_dict["tile"] = "",
		new_dict["rotation"] = rotation.y
	else:
		new_dict["tile"] = null,
		new_dict["rotation"] = 0

	return new_dict