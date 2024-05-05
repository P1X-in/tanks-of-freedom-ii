extends Node3D

@export var map: NodePath
var map_obj: Node

var marker_template = load("res://scenes/ui/markers/movement_marker.tscn")
var colour_materials = {
	"neutral" : ResourceLoader.load("res://assets/materials/arne32_neutral.tres"),
	"blue" : ResourceLoader.load("res://assets/materials/arne32_blue.tres"),
	"red" : ResourceLoader.load("res://assets/materials/arne32_red.tres"),
	"green" : ResourceLoader.load("res://assets/materials/arne32_green.tres"),
	"yellow" : ResourceLoader.load("res://assets/materials/arne32_yellow.tres"),
}

var explored_tiles = {}
var created_markers = {}
var tile_path = {}

func _ready():
	self.map_obj = self.get_node(self.map)

func reset():
	self.explored_tiles = {}
	self.tile_path = {}
	self.destroy_markers()

func destroy_markers():
	var marker
	for key in self.created_markers.keys():
		marker = self.created_markers[key]
		marker.hide()
		marker.queue_free()
	self.created_markers = {}

func show_unit_movement_markers_for_tile(tile, ap_limit):
	self.reset()
	self.add_path_root(tile)
	self.expand_from_tile(tile, tile.unit.tile.get_move(), 0, tile.unit.tile, ap_limit)

func mark_tile_cost(tile, cost):
	self.explored_tiles[self._get_key(tile)] = cost

func get_tile_cost(tile):
	var key = self._get_key(tile)
	if self.explored_tiles.has(key):
		return self.explored_tiles[key]

	return null

func expand_from_tile(tile, depth, reach_cost, unit, ap_limit):
	self.mark_tile_cost(tile, reach_cost)

	var neighbour
	var neighbour_cost

	if not self.marker_exists(tile.position) and tile.can_acommodate_unit(unit):
		self.place_movement_marker(tile.position)

	if self.marker_exists(tile.position):
		self.colour_marker(tile, unit, ap_limit)

	if depth < 1 || not tile.can_pass_through(unit) || reach_cost + 1 > ap_limit:
		return

	for key in tile.neighbours.keys():
		neighbour = tile.get_neighbour(key)

		neighbour_cost = self.get_tile_cost(neighbour)

		if neighbour_cost == null || neighbour_cost > reach_cost + 1:
			self.expand_from_tile(neighbour, depth - 1, reach_cost + 1, unit, ap_limit)
			self.connect_path(tile, neighbour)

func marker_exists(marker_position):
	return self.created_markers.has(str(marker_position.x) + "_" + str(marker_position.y))

func place_movement_marker(marker_position):
	var new_marker = self.marker_template.instantiate()
	self.add_child(new_marker)
	var placement = self.map_obj.map_to_local(marker_position)
	new_marker.set_position(placement)

	self.created_markers[str(marker_position.x) + "_" + str(marker_position.y)] = new_marker

func colour_marker(tile, unit, ap_limit):
	var marker
	var key = self._get_key(tile)

	marker = self.created_markers[key]

	if self.get_tile_cost(tile) == unit.move:
		marker.set_material(self.colour_materials["neutral"])
		return

	if self.get_tile_cost(tile) == ap_limit:
		marker.set_material(self.colour_materials["green"])
		return

	if tile.neighbours_enemy_unit(unit.side, unit.team) && tile.can_attack_neightbour_enemy_unit(unit) && unit.has_attacks():
		marker.set_material(self.colour_materials["red"])
		return

	if unit.can_capture && tile.neighbours_enemy_building(unit.side, unit.team):
		marker.set_material(self.colour_materials["blue"])
		return

	marker.set_material(self.colour_materials["green"])

func connect_path(source_tile, destination_tile):
	var source_key = self._get_key(source_tile)
	var destination_key = self._get_key(destination_tile)

	self.tile_path[destination_key] = source_key

func add_path_root(root_tile):
	self.tile_path[self._get_key(root_tile)] = null

func _get_key(tile):
	return str(tile.position.x) + "_" + str(tile.position.y)

func get_path_to_tile(destination_tile):
	var path = []
	var key = self._get_key(destination_tile)

	while key != null:
		path.append(key)
		key = self.tile_path[key]

	return path
