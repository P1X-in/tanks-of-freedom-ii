extends Node3D

const AUTOSAVE_FILE = "__autosave__"

@onready var map = $"map"
@onready var ui = $"ui"
@onready var map_list_service = $"/root/MapManager"
@onready var online_service = $"/root/Online"

@onready var audio = $"/root/SimpleAudioLibrary"
@onready var switcher = $"/root/SceneSwitcher"

var rotations = preload("res://scenes/map_editor/rotations.gd").new()
var radial_abilities = preload("res://scenes/board/logic/radial_abilities.gd").new()

var tile_rotation = 0
var selected_tile = "ground_grass"
var selected_class = "ground"
var mouse_click_position = null

var current_map_name = ""

const HISTORY_MAX_SIZE = 50
var actions_history = []

var picker_context = null

func _ready():
	self.rotations.build_rotations(self.map.templates, self.map.builder)
	self.select_tile(self.map.templates.GROUND_GRASS, self.map.builder.CLASS_GROUND)
	self.map.loader.load_map_file(self.AUTOSAVE_FILE)
	self.ui.load_minimap(self.AUTOSAVE_FILE)
	_load_map_settings()
	self.setup_radial_menu()
	self.ui.story.editor = self
	self.map.builder.editor = self
	self.map.tiles_frames_anchor.show()

	self.ui.radial.close_requested.connect(self.toggle_radial_menu)

	self.ui.edge_pan_left.mouse_entered.connect(self.map.camera._on_edge_pan.bind([1, null]))
	self.ui.edge_pan_left.mouse_exited.connect(self.map.camera._on_edge_pan.bind([0, null]))

	self.ui.edge_pan_right.mouse_entered.connect(self.map.camera._on_edge_pan.bind([-1, null]))
	self.ui.edge_pan_right.mouse_exited.connect(self.map.camera._on_edge_pan.bind([0, null]))

	self.ui.edge_pan_top.mouse_entered.connect(self.map.camera._on_edge_pan.bind([null, 1]))
	self.ui.edge_pan_top.mouse_exited.connect(self.map.camera._on_edge_pan.bind([null, 0]))

	self.ui.edge_pan_bottom.mouse_entered.connect(self.map.camera._on_edge_pan.bind([null, -1]))
	self.ui.edge_pan_bottom.mouse_exited.connect(self.map.camera._on_edge_pan.bind([null, 0]))

	self.ui.story.picker_requested.connect(self._on_picker_requested)


func _physics_process(_delta):
	self.update_ui_position()


func update_ui_position():
	self.ui.update_position(self.map.tile_box_position.x, self.map.tile_box_position.y)


func _input(event):
	if not get_window().has_focus():
		return

	if not self.ui.is_panel_open():
		if self.picker_context == null:
			_input_tile_edit(event)
		else:
			_input_picker(event)
	else:
		_input_menu(event)
		

func _input_tile_edit(event):
	if event.is_action_pressed("ui_accept"):
		self.place_tile()
		self.audio.play("menu_click")

	if event.is_action_pressed("mouse_click"):
		self.mouse_click_position = event.position
	if event.is_action_released("mouse_click"):
		if self.mouse_click_position != null and event.position.distance_squared_to(self.mouse_click_position) < self.map.camera.MOUSE_MOVE_THRESHOLD:
			self.audio.play("menu_click")
			self.place_tile()
		self.mouse_click_position = null

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

	if event.is_action_pressed("ui_cancel"):
		if event is InputEventMouseButton:
			self.mouse_click_position = event.position
	if event.is_action_released("ui_cancel"):
		if (self.mouse_click_position != null and event.position.distance_squared_to(self.mouse_click_position) < self.map.camera.MOUSE_MOVE_THRESHOLD) or not event is InputEventMouseButton:
			self.audio.play("menu_click")
			self.undo_action()
		self.mouse_click_position = null

	if event.is_action_pressed("editor_ban_menu"):
		self._open_ability_ban_menu()
		self.audio.play("menu_click")

	if event.is_action_pressed("editor_ai_pause"):
		self.toggle_unit_ai_pause()
		self.audio.play("menu_click")

func _input_picker(event):
	if event.is_action_pressed("ui_accept"):
		self._confirm_position_pick()
		self.audio.play("menu_click")

	if event.is_action_pressed("mouse_click"):
		self.mouse_click_position = event.position
	if event.is_action_released("mouse_click"):
		if self.mouse_click_position != null and event.position.distance_squared_to(self.mouse_click_position) < self.map.camera.MOUSE_MOVE_THRESHOLD:
			self.audio.play("menu_click")
			self._confirm_position_pick()
		self.mouse_click_position = null

	if event.is_action_pressed("ui_cancel"):
		if event is InputEventMouseButton:
			self.mouse_click_position = event.position
	if event.is_action_released("ui_cancel"):
		if (self.mouse_click_position != null and event.position.distance_squared_to(self.mouse_click_position) < self.map.camera.MOUSE_MOVE_THRESHOLD) or not event is InputEventMouseButton:
			self.audio.play("menu_click")
			_cancel_position_pick()
		self.mouse_click_position = null

	if event.is_action_pressed("editor_menu"):
		_cancel_position_pick()
		self.audio.play("menu_click")

func _input_menu(event):
	if self.ui.radial.is_visible() and not self.ui.is_popup_open():
		if event.is_action_pressed("ui_cancel"):
			self.toggle_radial_menu()
			self.audio.play("menu_click")

		if event.is_action_pressed("editor_menu"):
			self.toggle_radial_menu()
			self.audio.play("menu_click")

	if self.ui.story.is_visible():
		if event.is_action_pressed("ui_cancel"):
			self.ui.story._on_back_button_pressed()
			self.audio.play("menu_click")

		if event.is_action_pressed("editor_menu"):
			self.ui.story._on_back_button_pressed()
			self.audio.play("menu_click")

func autosave():
	_apply_map_settings()
	self.map.loader.save_map_file(self.AUTOSAVE_FILE)
	self.ui.load_minimap(self.AUTOSAVE_FILE)


func place_tile():
	var tile = self.map.model.get_tile(self.map.tile_box_position)
	if tile == null:
		return

	self.write_action_history({
		"type" : "add",
		"class" : self.selected_class,
		"position" : self.map.tile_box_position,
		"tile" : self.selected_tile,
		"rotation" : self.tile_rotation,
	})
	self._place_tile(self.selected_class, self.map.tile_box_position, self.selected_tile, self.tile_rotation)
	self.autosave()

func _place_tile(tile_class, tile_position, tile_type, _tile_rotation):
	if tile_class == self.map.builder.CLASS_GROUND:
		self.map.builder.place_ground(tile_position, tile_type, _tile_rotation)
	if tile_class == self.map.builder.CLASS_FRAME:
		self.map.builder.place_frame(tile_position, tile_type, _tile_rotation)
	if tile_class == self.map.builder.CLASS_DECORATION:
		self.map.builder.place_decoration(tile_position, tile_type, _tile_rotation)
	if tile_class == self.map.builder.CLASS_DAMAGE:
		self.map.builder.place_damage(tile_position, tile_type, _tile_rotation)
	if tile_class == self.map.builder.CLASS_TERRAIN:
		self.map.builder.place_terrain(tile_position, tile_type, _tile_rotation)
	if tile_class == self.map.builder.SUB_CLASS_CONSTRUCTION:
		self.map.builder.place_terrain(tile_position, tile_type, _tile_rotation)
	if tile_class == self.map.builder.CLASS_BUILDING:
		self.map.builder.place_building(tile_position, tile_type, _tile_rotation)
	if tile_class == self.map.builder.CLASS_UNIT or tile_class == self.map.builder.CLASS_HERO:
		self.map.builder.place_unit(tile_position, tile_type, _tile_rotation)


func clear_tile():
	self.map.builder.clear_tile_layer(self.map.tile_box_position)
	self.autosave()

func undo_action():
	if self.actions_history.size() > 0:
		var recent_action = self.actions_history.pop_back()
		var tile = self.map.model.get_tile(recent_action["position"])

		if recent_action["type"] == "add":
			match recent_action["class"]:
				"ground":
					tile.ground.clear()
				"frame":
					tile.frame.clear()
				"decoration":
					tile.decoration.clear()
				"damage":
					tile.damage.clear()
				"terrain":
					tile.terrain.clear()
				"construction":
					tile.terrain.clear()
				"building":
					tile.building.clear()
				"unit":
					tile.unit.clear()
				"hero":
					tile.unit.clear()
		elif recent_action["type"] == "remove":
			if recent_action["double"]:
				self.undo_action()
			self._place_tile(recent_action["class"], recent_action["position"], recent_action["tile"], recent_action["rotation"])
			match recent_action["class"]:
				"building":
					self.map.builder.set_building_side(recent_action["position"], recent_action["side"])
					tile.building.tile.restore_abilities_status(recent_action["modifiers"])
				"unit":
					self.map.builder.set_unit_side(recent_action["position"], recent_action["side"])
				"hero":
					self.map.builder.set_unit_side(recent_action["position"], recent_action["side"])
		elif recent_action["type"] == "side":
			match recent_action["class"]:
				"building":
					self.map.builder.set_building_side(recent_action["position"], recent_action["old_side"])
				"unit":
					self.map.builder.set_unit_side(recent_action["position"], recent_action["old_side"])
		self.autosave()

func refresh_tile():
	self.select_tile(self.selected_tile, self.selected_class)

func select_tile(tile_name, type):
	self.selected_tile = tile_name
	self.selected_class = type

	var rotation_map = self.rotations.get_map(tile_name, type)
	var type_map = self.rotations.get_type_map(self.selected_class)
	var first_tile

	self.rotations.store_state(type, tile_name)

	self.ui.set_tile_prev(self.map.templates.get_template(rotation_map["prev"]), self.tile_rotation)
	self.ui.set_tile_current(self.map.templates.get_template(tile_name), self.tile_rotation)
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


func toggle_radial_menu(context_object=null):
	if self.radial_abilities.is_object_without_abilities(self, context_object, true):
		return

	if not self.ui.is_radial_open():
		self.setup_radial_menu(context_object)
	else:
		self.map.camera.force_stick_reset()

	self.ui.toggle_radial()
	self.map.camera.paused = not self.map.camera.paused
	self.map.tile_box.set_visible(not self.map.tile_box.is_visible())

func setup_radial_menu(context_object=null):
	self.ui.radial.clear_fields()
	if context_object == null:
		self.ui.radial.set_field(self.ui.icons.trash.instantiate(), "TR_WIPE_EDITOR", 0, self, "wipe_editor")
		if self.current_map_name != "" and not self.map_list_service.is_reserved_name(current_map_name):
			self.ui.radial.set_field(self.ui.icons.quicksave.instantiate(), "TR_QUICKSAVE", 1, self, "quicksave")
		self.ui.radial.set_field(self.ui.icons.disk.instantiate(), "TR_SAVE_LOAD_MAP", 2, self, "open_picker")
		self.ui.radial.set_field(self.ui.icons.tof.instantiate(), "TR_TOF1_IMPORT", 3, self, "open_tof_import")
		self.ui.radial.set_field(self.ui.icons.quit.instantiate(), "TR_MAIN_MENU", 4, self.switcher, "main_menu")
		self.ui.radial.set_field(self.ui.icons.cog.instantiate(), "TR_MAP_SETTINGS", 5, self, "open_story")
		self.ui.radial.set_field(self.ui.icons.cross.instantiate(), "TR_CLOSE", 6, self, "toggle_radial_menu")
	else:
		self.radial_abilities.fill_radial_with_ability_bans(self, self.ui.radial, context_object)

func handle_picker_output(args):
	var map_name = args[0]
	var context = args[1]

	if context == "save":
		_apply_map_settings()
		self.map.loader.save_map_file(map_name)
		self.map_list_service.add_map_to_list(map_name)
		self.ui.picker.minimap.remove_from_cache(map_name)
	elif context == "load":
		self.map.loader.load_map_file(map_name)
		self.ui.load_minimap(map_name)
		self.actions_history = []
		_load_map_settings()

	self.close_picker()
	self.set_map_name(map_name)
	if self.map.model.metadata.has("name"):
		self.set_map_name(self.map.model.metadata["name"])


func quicksave():
	if self.current_map_name != "":
		_apply_map_settings()
		self.map.loader.save_map_file(self.current_map_name)
	self.toggle_radial_menu()

func _load_map_settings():
	self.ui.story.ingest_map_data(self.map.model.metadata, self.map.model.scripts["triggers"], self.map.model.scripts["stories"])

func _apply_map_settings():
	self.map.model.metadata = self.ui.story.fill_metadata(self.map.model.metadata)
	self.map.model.scripts["triggers"] = self.ui.story.compile_triggers()
	self.map.model.scripts["stories"] = self.ui.story.compile_stories()

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
	self.ui.show_position()

func open_tof_import():
	self.ui.hide_radial()
	self.ui.picker.set_browse_v1_mode()
	self.ui.show_picker()

	self.ui.picker.bind_cancel(self, "close_tof_import")
	self.ui.picker.bind_success(self, "handle_tof_import")

func close_tof_import():
	self.ui.hide_picker()
	self.ui.picker.unlock_tab_bar()
	self.ui.picker.list_mode = self.ui.picker.map_list_service.LIST_STOCK
	self.ui.picker.current_page = 0
	self.map.camera.paused = false
	self.map.tile_box.set_visible(true)
	self.online_service.set_api_version(2)
	self.ui.show_tiles()
	self.ui.show_position()

func handle_tof_import(args):
	var code = args[0]
	self.close_tof_import()
	var result = await self.online_service.maps.download_map(code, 1)
	if result['status'] == 'ok':
		self.ui.set_map_name(result["data"]["data"]["name"])
		self.map.loader.load_from_v1_data(result["data"])
	self.autosave()

func open_story():
	self.ui.hide_radial()
	self.ui.show_story()

func close_story():
	self.ui.hide_story()
	self.map.camera.paused = false
	self.map.tile_box.set_visible(true)
	self.ui.show_tiles()
	self.ui.show_position()

func wipe_editor():
	self.toggle_radial_menu()
	self.set_map_name("")
	self.map.builder.wipe_map()
	self.ui.wipe_minimap()
	self.map.model.wipe_metadata()
	self.map.model.wipe_scripts()
	self.actions_history = []

func next_alternative():
	var tile = self.map.model.get_tile(self.map.tile_box_position)
	var old_side

	if tile.building.is_present():
		old_side = tile.building.tile.side
		self.next_building_side(tile.building.tile)
		self.write_action_history({
			"type" : "side",
			"class" : "building",
			"position" : self.map.tile_box_position,
			"old_side" : old_side,
			"new_side" : tile.building.tile.side,
		})

	if tile.unit.is_present():
		old_side = tile.unit.tile.side
		self.next_unit_side(tile.unit.tile)
		self.write_action_history({
			"type" : "side",
			"class" : "unit",
			"position" : self.map.tile_box_position,
			"old_side" : old_side,
			"new_side" : tile.unit.tile.side,
		})

	if tile.terrain.is_present() and tile.terrain.tile.is_damageable():
		self.next_damage_stage(tile)
	elif tile.terrain.is_present() and tile.terrain.tile.is_restoreable():
		self.restore_damage_stage(tile)

	self.autosave()

func next_building_side(building_object):
	var side_map = self.rotations.get_player_map(building_object.side)
	self.map.builder.set_building_side(self.map.tile_box_position, side_map["next"])

func next_unit_side(unit_object):
	var side_map = self.rotations.get_player_map(unit_object.side)

	#if side_map["next"] == "neutral":
	#    side_map = self.rotations.get_player_map(side_map["next"])

	self.map.builder.set_unit_side(self.map.tile_box_position, side_map["next"])

func next_damage_stage(tile):
	self.replace_terrain(tile, tile.terrain.tile.next_damage_stage_template)

func restore_damage_stage(tile):
	self.replace_terrain(tile, tile.terrain.tile.base_stage_template)

func replace_terrain(tile, template_name):
	var t_rotation = tile.terrain.tile.get_rotation_degrees()

	tile.terrain.clear()
	self.map.builder.place_terrain(tile.position, template_name, t_rotation.y)

func notify_about_removal(action_details):
	self.write_action_history(action_details)

func _open_ability_ban_menu():
	var tile = self.map.model.get_tile(self.map.tile_box_position)
	if tile.building.is_present():
		self.toggle_radial_menu(tile.building.tile)

func toggle_unit_ai_pause():
	var tile = self.map.model.get_tile(self.map.tile_box_position)
	if tile.unit.is_present():
		tile.unit.tile.ai_paused = not tile.unit.tile.ai_paused

		if tile.unit.tile.ai_paused:
			tile.unit.tile.remove_highlight()
		else:
			tile.unit.tile.restore_highlight()

func write_action_history(action_details):
	self.actions_history.append(action_details)


func _on_picker_requested(context):
	self.picker_context = context

	if context.has("position") and context["position"] is Array:
		self.map.snap_camera_to_position(Vector2(context["position"][0], context["position"][1]))

	self.ui.hide_story()
	self.map.camera.paused = false
	self.map.tile_box.set_visible(true)
	self.ui.show_minimap()
	self.ui.show_position()

func _confirm_position_pick():
	self.ui.story._handle_picker_response(self.map.tile_box_position, self.picker_context)
	self.picker_context = null

	self.ui.show_story()
	self.map.camera.paused = true
	self.map.tile_box.set_visible(false)
	self.ui.hide_minimap()
	self.ui.hide_position()

func _cancel_position_pick():
	self.picker_context = null

	self.ui.show_story()
	self.map.camera.paused = true
	self.map.tile_box.set_visible(false)
	self.ui.hide_minimap()
	self.ui.hide_position()
