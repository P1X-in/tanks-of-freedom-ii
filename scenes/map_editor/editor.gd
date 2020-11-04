extends Spatial

const AUTOSAVE_FILE = "__autosave__"

var map
var ui

var rotations = preload("res://scenes/map_editor/rotations.gd").new()

var tile_rotation = 0
var selected_tile = "ground_grass"
var selected_class = "ground"

func _ready():
	self.map = $"map"
	self.ui = $"ui"

	self.rotations.build_rotations(self.map.templates, self.map.builder)

	self.select_tile(self.map.templates.GROUND_GRASS, self.map.builder.CLASS_GROUND)

	self.map.loader.load_map_file(self.AUTOSAVE_FILE)
	

func _physics_process(_delta):
	self.update_ui_position()


func update_ui_position():
	self.ui.update_position(self.map.camera_tile_position.x, self.map.camera_tile_position.y)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		self.place_tile()

	if event.is_action_pressed("ui_cancel"):
		self.clear_tile()

	if event.is_action_pressed("ui_left"):
		self.switch_to_prev_tile()

	if event.is_action_pressed("ui_right"):
		self.switch_to_next_tile()

	if event.is_action_pressed("ui_up"):
		self.switch_to_next_type()

	if event.is_action_pressed("ui_down"):
		self.switch_to_prev_type()

	if event.is_action_pressed("rotate_cw"):
		self.rotate_cw()
		self.refresh_tile()

	if event.is_action_pressed("rotate_ccw"):
		self.rotate_ccw()
		self.refresh_tile()
		

func place_tile():
	if self.selected_class == self.map.builder.CLASS_GROUND:
		self.map.builder.place_ground(self.map.camera_tile_position, self.selected_tile, self.tile_rotation)
	if self.selected_class == self.map.builder.CLASS_FRAME:
		self.map.builder.place_frame(self.map.camera_tile_position, self.selected_tile, self.tile_rotation)
	if self.selected_class == self.map.builder.CLASS_DECORATION:
		self.map.builder.place_decoration(self.map.camera_tile_position, self.selected_tile, self.tile_rotation)
	if self.selected_class == self.map.builder.CLASS_TERRAIN:
		self.map.builder.place_terrain(self.map.camera_tile_position, self.selected_tile, self.tile_rotation)
	if self.selected_class == self.map.builder.CLASS_BUILDING:
		self.map.builder.place_building(self.map.camera_tile_position, self.selected_tile, self.tile_rotation)
	if self.selected_class == self.map.builder.CLASS_UNIT:
		self.map.builder.place_unit(self.map.camera_tile_position, self.selected_tile, self.tile_rotation)

	self.map.loader.save_map_file(self.AUTOSAVE_FILE)

func clear_tile():
	self.map.builder.clear_tile_layer(self.map.camera_tile_position)
	self.map.loader.save_map_file(self.AUTOSAVE_FILE)

func refresh_tile():
	self.select_tile(self.selected_tile, self.selected_class)

func select_tile(name, type):
	self.selected_tile = name
	self.selected_class = type

	var rotation_map = self.rotations.get_map(name, type)
	var type_map = self.rotations.get_type_map(self.selected_class)
	var first_tile

	self.ui.set_tile_prev(self.map.templates.get_template(rotation_map["prev"]), self.tile_rotation)
	self.ui.set_tile_current(self.map.templates.get_template(name), self.tile_rotation)
	self.ui.set_tile_next(self.map.templates.get_template(rotation_map["next"]), self.tile_rotation)

	first_tile = self.rotations.get_first_tile(type_map["prev"])
	self.ui.set_type_prev(self.map.templates.get_template(first_tile), self.tile_rotation)
	first_tile = self.rotations.get_first_tile(type_map["next"])
	self.ui.set_type_next(self.map.templates.get_template(first_tile), self.tile_rotation)
	

func switch_to_prev_tile():
	var rotation_map = self.rotations.get_map(self.selected_tile, self.selected_class)
	self.select_tile(rotation_map["prev"], self.selected_class) 

func switch_to_next_tile():
	var rotation_map = self.rotations.get_map(self.selected_tile, self.selected_class)
	self.select_tile(rotation_map["next"], self.selected_class)


func rotate_ccw():
	self.tile_rotation += 90
	if self.tile_rotation >= 360:
		self.tile_rotation = 0

func rotate_cw():
	self.tile_rotation -= 90
	if self.tile_rotation < 0:
		self.tile_rotation = 270


func switch_to_prev_type():
	var type_map = self.rotations.get_type_map(self.selected_class)
	var first_tile = self.rotations.get_first_tile(type_map["prev"])
	self.select_tile(first_tile, type_map["prev"])

func switch_to_next_type():
	var type_map = self.rotations.get_type_map(self.selected_class)
	var first_tile = self.rotations.get_first_tile(type_map["next"])
	self.select_tile(first_tile, type_map["next"])
