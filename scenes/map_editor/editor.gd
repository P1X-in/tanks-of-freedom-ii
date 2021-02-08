extends Spatial

const AUTOSAVE_FILE = "__autosave__"

onready var map = $"map"
onready var ui = $"ui"
onready var map_list_service = $"/root/MapList"

onready var audio = $"/root/SimpleAudioLibrary"

var rotations = preload("res://scenes/map_editor/rotations.gd").new()

var tile_rotation = 0
var selected_tile = "ground_grass"
var selected_class = "ground"

var current_map_name = ""

func _ready():
    self.rotations.build_rotations(self.map.templates, self.map.builder)
    self.select_tile(self.map.templates.GROUND_GRASS, self.map.builder.CLASS_GROUND)
    self.map.loader.load_map_file(self.AUTOSAVE_FILE)
    self.ui.load_minimap(self.AUTOSAVE_FILE)
    self.setup_radial_menu()
    

func _physics_process(_delta):
    self.update_ui_position()


func update_ui_position():
    self.ui.update_position(self.map.camera_tile_position.x, self.map.camera_tile_position.y)


func _input(event):
    if not self.ui.is_panel_open():
        if event.is_action_pressed("ui_accept"):
            self.place_tile()
            self.audio.play("menu_click")

        if event.is_action_pressed("editor_clear"):
            self.clear_tile()
            self.audio.play("menu_click")

        if event.is_action_pressed("editor_next_alternative"):
            self.next_alternative()
            self.audio.play("menu_click")

        if event.is_action_pressed("ui_left"):
            self.switch_to_prev_tile()
            self.audio.play("menu_click")

        if event.is_action_pressed("ui_right"):
            self.switch_to_next_tile()
            self.audio.play("menu_click")

        if event.is_action_pressed("ui_up"):
            self.switch_to_next_type()
            self.audio.play("menu_click")

        if event.is_action_pressed("ui_down"):
            self.switch_to_prev_type()
            self.audio.play("menu_click")

        if event.is_action_pressed("rotate_cw"):
            self.rotate_cw()
            self.refresh_tile()
            self.audio.play("menu_click")

        if event.is_action_pressed("rotate_ccw"):
            self.rotate_ccw()
            self.refresh_tile()
            self.audio.play("menu_click")

        if event.is_action_pressed("editor_menu"):
            self.toggle_radial_menu()
            self.audio.play("menu_click")
    else:
        if self.ui.radial.is_visible() and not self.ui.is_popup_open():
            if event.is_action_pressed("ui_cancel"):
                self.toggle_radial_menu()
                self.audio.play("menu_click")

            if event.is_action_pressed("editor_menu"):
                self.toggle_radial_menu()
                self.audio.play("menu_click")
    

func autosave():
    self.map.loader.save_map_file(self.AUTOSAVE_FILE)
    self.ui.load_minimap(self.AUTOSAVE_FILE)


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

    self.autosave()

func clear_tile():
    self.map.builder.clear_tile_layer(self.map.camera_tile_position)
    self.autosave()

func refresh_tile():
    self.select_tile(self.selected_tile, self.selected_class)

func select_tile(name, type):
    self.selected_tile = name
    self.selected_class = type

    var rotation_map = self.rotations.get_map(name, type)
    var type_map = self.rotations.get_type_map(self.selected_class)
    var first_tile

    self.rotations.store_state(type, name)

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


func toggle_radial_menu():
    self.ui.toggle_radial()
    self.map.camera.paused = not self.map.camera.paused
    self.map.tile_box.set_visible(not self.map.tile_box.is_visible())

func setup_radial_menu():
    self.ui.radial.set_field(self.ui.icons.disk.instance(), "Save/Load map", 2, self, "open_picker")
    self.ui.radial.set_field(self.ui.icons.back.instance(), "Main menu", 6, get_tree(), "quit")
    self.ui.radial.set_field(self.ui.icons.trash.instance(), "Clear editor", 4, self, "wipe_editor")


func handle_picker_output(args):
    var map_name = args[0]
    var context = args[1]

    if context == "save":
        self.map.loader.save_map_file(map_name)
        self.map_list_service.add_map_to_list(map_name)
        self.ui.picker.minimap.remove_from_cache(map_name)
    elif context == "load":
        self.map.loader.load_map_file(map_name)
        self.ui.load_minimap(map_name)
        
    self.close_picker()
    self.set_map_name(map_name)


func set_map_name(map_name):
    self.current_map_name = map_name
    self.ui.set_map_name(map_name)

func open_picker():
    self.ui.hide_radial()
    self.ui.show_picker()

    self.ui.picker.bind_cancel(self, "close_picker")
    self.ui.picker.bind_success(self, "handle_picker_output")
    self.ui.picker.set_name_mode()
    self.ui.set_map_name(self.current_map_name, true)

func close_picker():
    self.ui.hide_picker()
    self.map.camera.paused = false
    self.map.tile_box.set_visible(true)
    self.ui.show_tiles()

func wipe_editor():
    self.toggle_radial_menu()
    self.set_map_name("")
    self.map.builder.wipe_map()
    self.ui.wipe_minimap()

func next_alternative():
    var tile = self.map.model.get_tile(self.map.camera_tile_position)

    if tile.building.is_present():
        self.next_building_side(tile.building.tile)

    if tile.unit.is_present():
        self.next_unit_side(tile.unit.tile)
        
    self.autosave()

func next_building_side(building_object):
    var side_map = self.rotations.get_player_map(building_object.side)
    self.map.builder.set_building_side(self.map.camera_tile_position, side_map["next"])

func next_unit_side(unit_object):
    var side_map = self.rotations.get_player_map(unit_object.side)

    if side_map["next"] == "neutral":
        side_map = self.rotations.get_player_map(side_map["next"])

    self.map.builder.set_unit_side(self.map.camera_tile_position, side_map["next"])
    
