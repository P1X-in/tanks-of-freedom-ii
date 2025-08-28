extends Node

var initialized := false
var mouse_layer := Node3D.new()
var ground_points: Dictionary[String, Node] = {}
var dummy_ground_template: PackedScene = preload("res://scenes/tiles/ground/base_ground.tscn")

func initialize(size, tile_size) -> void:
	if self.initialized:
		return

	self.initialized = true
	var key
	for x in range(size):
		for y in range(size):
			key = str(x) + "_" + str(y)
			self.ground_points[key] = self.dummy_ground_template.instantiate()
			self.mouse_layer.add_child(self.ground_points[key])
			self.ground_points[key].prepare()
			self.ground_points[key].mouse_collision.connect("mouse_entered", Callable(self.ground_points[key].mouse_collision, "_on_mouse_collision_mouse_entered"))
			self.ground_points[key].set_position(Vector3(x * tile_size, 0, y * tile_size))


func detach() -> void:
	var parent := self.mouse_layer.get_parent()
	if parent != null:
		parent.remove_child(self.mouse_layer)

func destroy() -> void:
	self.mouse_layer.free()
