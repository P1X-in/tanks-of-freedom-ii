extends Node3D

@export var map: NodePath;
var map_obj: Node

var marker_template = preload("res://scenes/ui/markers/path_marker.tscn")

var created_markers = {}

var rotations = {
	"n" : 0,
	"s" : 180,
	"w" : 90,
	"e" : 270,
}

func _ready():
	self.map_obj = self.get_node(self.map)

func reset():
	self.destroy_markers()

func destroy_markers():
	var marker
	for key in self.created_markers.keys():
		marker = self.created_markers[key]
		marker.hide()
		marker.queue_free()
	self.created_markers = {}


func draw_path(path):
	self.reset()

	for i in path.size():
		if i < path.size() - 1:
			self.place_marker(path[i])

	self.rotate_markers(path)
	

func place_marker(tile_key):
	var tile = self.map_obj.model.tiles[tile_key]
	var new_marker = self.marker_template.instantiate()
	self.add_child(new_marker)
	var placement = self.map_obj.map_to_local(tile.position)
	new_marker.set_position(placement)

	self.created_markers[tile_key] = new_marker

func rotate_markers(path):
	for i in path.size():
		if i < path.size() - 1:
			if i > 0:
				self.rotate_marker(self.created_markers[path[i]], path[i], path[i-1])
			elif i == 0:
				self.rotate_marker(self.created_markers[path[i]], path[i+1], path[i])

func convert_path_to_directions(path):
	var directions = []
	for i in path.size():
		if i > 0:
			directions.append(self.get_rotation_to_tile(path[i], path[i-1]))
		elif i == 0:
			directions.append(self.get_rotation_to_tile(path[i+1], path[i]))

	directions.reverse()
	return directions

func get_rotation_to_tile(source_key, destination_key):                
	var source_tile = self.map_obj.model.tiles[source_key]
	var destination_tile = self.map_obj.model.tiles[destination_key]
	return source_tile.get_direction_to_neighbour(destination_tile)

func rotate_marker(marker, source_key, destination_key):
	var direction = self.get_rotation_to_tile(source_key, destination_key)

	marker.set_rotation(Vector3(0, deg_to_rad(self.rotations[direction]), 0))

func get_final_field_unit_direction(path):
	return self.get_rotation_to_tile(path[1], path[0])
