extends Node3D

const TILE_SIZE = 8
const GROUND_HEIGHT = 4

@onready var tile_box = $"tiles/tile_box"
@onready var camera = $"camera"
@onready var campaign = $"/root/Campaign"
@onready var mouse_layer = $"/root/MouseLayer"
@onready var settings = $"/root/Settings"

var tile_box_space_size
var tile_box_position = Vector2(0, 0)
var tile_box_mouse = false

var templates = preload("res://scenes/map/templates.gd").new()
var model = preload("res://scenes/map/model.gd").new()
var builder = preload("res://scenes/map/builder.gd").new(self)
var loader = preload("res://scenes/map/loader.gd").new(self)

@onready var tiles_ground_anchor = $"tiles/ground"
@onready var tiles_frames_anchor = $"tiles/frames"
@onready var tiles_terrain_anchor = $"tiles/terrain"
@onready var tiles_buildings_anchor = $"tiles/buildings"
@onready var tiles_units_anchor = $"tiles/units"

func _ready():
	self.tile_box_space_size = self.camera.camera_space_size - self.TILE_SIZE

	self.settings.changed.connect(_settings_changed)
	for i in self.model.tiles.keys():
		self.model.tiles[i].settings = self.settings
		self.settings.changed.connect(self.model.tiles[i]._settings_changed)

	if not self.settings.get_option("decorations"):
		self.tiles_frames_anchor.hide()

func _input(event):
	if event is InputEventMouseMotion:
		if event.relative.length_squared() > 0.01:
			self.tile_box_mouse = true

func _physics_process(_delta):
	self._manage_mouse_input()
	self.update_tile_box_position_from_camera()
	self.snap_tile_box()

func _manage_mouse_input():
	var gamepad_offset = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)
	if gamepad_offset.length_squared() > 0.1:
		self.tile_box_mouse = false


func update_tile_box_position_from_camera():
	if self.camera.snap_tile_box_to_camera:
		self.tile_box_position = self.local_to_map(self.camera.get_position())

func set_tile_box_position(box_position):
	self.camera.snap_tile_box_to_camera = false
	self.tile_box_position = box_position

func set_mouse_box_position(box_position):
	if self.tile_box_mouse:
		self.set_tile_box_position(box_position)


func snap_tile_box():
	var box_position = self.tile_box.get_position()
	var placement = self.map_to_local(self.tile_box_position)

	placement.y = box_position.y

	self.tile_box.set_position(placement)

func map_to_local(queried_position):
	return Vector3(queried_position.x * self.TILE_SIZE, 0, queried_position.y * self.TILE_SIZE)

func local_to_map(queried_position):
	var tile_position = Vector2(0, 0)

	if queried_position.x == self.camera.camera_space_size:
		queried_position.x = self.tile_box_space_size
	if queried_position.z == self.camera.camera_space_size:
		queried_position.z = self.tile_box_space_size

	var camera_position_x = int(queried_position.x)
	var camera_position_z = int(queried_position.z)

	@warning_ignore("integer_division")
	tile_position.x = (camera_position_x - (camera_position_x % self.TILE_SIZE)) / self.TILE_SIZE
	@warning_ignore("integer_division")
	tile_position.y = (camera_position_z - (camera_position_z % self.TILE_SIZE)) / self.TILE_SIZE

	return tile_position


func set_tile_box_side(side):
	self.tile_box.set_mesh_material(self.templates.get_side_material(side))

func show_tile_box():
	self.tile_box.show()

func hide_tile_box():
	self.tile_box.hide()

func move_camera_to_position(destination):
	if destination == null:
		return

	self.camera.move_camera_to_position(destination * self.TILE_SIZE + Vector2(0.5, 0.5) * self.TILE_SIZE)

func move_camera_to_position_if_far_away(destination, tolerance=5, zoom=null):
	if zoom != null:
		self.camera.set_camera_zoom(zoom)

	if destination == null:
		return false

	self.update_tile_box_position_from_camera()
	var adj_tol = tolerance * self.camera.get_zoom_fraction()
	if self.tile_box_position.distance_squared_to(destination) > (adj_tol * adj_tol) or zoom != null:
		self.move_camera_to_position(destination)

	return true

func snap_camera_to_position(destination):
	self.camera.set_camera_position(destination * self.TILE_SIZE + Vector2(0.5, 0.5) * self.TILE_SIZE)

func anchor_unit(unit, unit_position):
	var world_position = self.map_to_local(unit_position)
	world_position.y = self.GROUND_HEIGHT
	self.tiles_units_anchor.add_child(unit)
	unit.set_position(world_position)
	

func detach_unit(unit):
	self.tiles_units_anchor.remove_child(unit)

func hide_invisible_tiles():
	for i in self.model.tiles.keys():
		self.model.tiles[i].apply_invisibility()


func _settings_changed(key, new_value):
	if key == "decorations":
		if new_value:
			self.tiles_frames_anchor.show()
		else:
			self.tiles_frames_anchor.hide()
