extends Area3D

var tile_position = Vector2(0, 0)
var map = null

func _on_mouse_collision_mouse_entered():
	if self.map != null:
		self.map.set_mouse_box_position(self.tile_position)
