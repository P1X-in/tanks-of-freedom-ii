extends Node2D

var editor

@onready var map_settings_button = $"widgets/tabs/map_settings_button"
@onready var audio = $"/root/SimpleAudioLibrary"

@onready var map_settings_panel = $"widgets/panels/MapSettings"
@onready var triggers_panel = $"widgets/panels/Triggers"
@onready var stories_panel = $"widgets/panels/Stories"

@onready var picker_panel = $"widgets/panels/StoryElementPicker"

signal picker_requested(context)

func _ready():
	self.map_settings_panel.picker_requested.connect(self._on_picker_requested)
	self.triggers_panel.picker_requested.connect(self._on_picker_requested)
	self.stories_panel.picker_requested.connect(self._on_picker_requested)
	self.picker_panel.value_selected.connect(self._on_picker_value_selected)
	_switch_to_panel(self.map_settings_panel)

func show_panel():
	self.show()
	self.map_settings_button.grab_focus()


func _switch_to_panel(panel):
	self.map_settings_panel.hide()
	self.triggers_panel.hide()
	self.stories_panel.hide()
	self.picker_panel.hide()
	panel.show_panel()

func ingest_map_data(metadata, triggers, stories):
	self.map_settings_panel.ingest_metadata(metadata)
	self.triggers_panel.ingest_triggers_data(triggers)
	self.stories_panel.ingest_stories_data(stories)

func fill_metadata(metadata):
	return self.map_settings_panel.fill_metadata(metadata)

func compile_triggers():
	return self.triggers_panel.compile_triggers_data()

func compile_stories():
	return self.stories_panel.compile_stories_data()

func _on_map_settings_button_pressed():
	self.audio.play("menu_click")
	_switch_to_panel(self.map_settings_panel)


func _on_triggers_button_pressed():
	self.audio.play("menu_click")
	_switch_to_panel(self.triggers_panel)


func _on_stories_button_pressed():
	self.audio.play("menu_click")
	_switch_to_panel(self.stories_panel)


func _on_back_button_pressed():
	self.audio.play("menu_back")
	if self.picker_panel.is_visible():
		if self.picker_panel.picker_context["tab"] == "triggers":
			_switch_to_panel(self.triggers_panel)
		if self.picker_panel.picker_context["tab"] == "stories":
			_switch_to_panel(self.stories_panel)
		return
	if self.stories_panel.is_visible():
		if self.stories_panel._on_back_button_pressed():
			return
	if self.editor != null:
		self.editor.close_story()


func _on_picker_requested(context):
	if context["type"] == "position":
		self.picker_requested.emit(context)
	else:
		if context["type"] == "trigger":
			self.picker_panel.load_list(self.triggers_panel._get_sorted_trigger_names(), context)
		if context["type"] == "story":
			self.picker_panel.load_list(self.stories_panel._get_sorted_stories_names(), context)
		if context["type"] == "unit_type":
			self.picker_panel.load_list(
				self.editor.map.templates._unit_templates.keys() + self.editor.map.templates._hero_templates.keys(), 
				context
			)
		if context["type"] == "side":
			self.picker_panel.load_list(
				self.editor.map.templates.side_materials.keys(), 
				context
			)
		if context["type"] == "portrait":
			self.picker_panel.load_list(
				self.editor.map.templates._unit_templates.keys() + self.editor.map.templates._hero_templates.keys() + self.editor.map.templates._building_templates.keys(), 
				context
			)
		if context["type"] == "sound":
			self.picker_panel.load_list(
				self.editor.audio.samples.keys(), 
				context
			)
		if context["type"] == "tile_type":
			self.picker_panel.load_list(
				["decoration","damage","frame","terrain","ground","building"], 
				context
			)
		if context["type"] == "template":
			if context["tile_type"] == "decoration":
				self.picker_panel.load_list(
					self.editor.map.templates._decoration_templates.keys() + self.editor.map.templates._special_templates.keys(), 
					context
				)
			if context["tile_type"] == "damage":
				self.picker_panel.load_list(
					self.editor.map.templates._damage_templates.keys(), 
					context
				)
			if context["tile_type"] == "frame":
				self.picker_panel.load_list(
					self.editor.map.templates._frame_templates.keys(), 
					context
				)
			if context["tile_type"] == "terrain":
				self.picker_panel.load_list(
					self.editor.map.templates._city_templates.keys() + self.editor.map.templates._city_decoration_templates.keys() + self.editor.map.templates._wall_templates.keys() + self.editor.map.templates._railway_templates.keys() + self.editor.map.templates._nature_templates.keys(), 
					context
				)
			if context["tile_type"] == "ground":
				self.picker_panel.load_list(
					self.editor.map.templates._ground_templates.keys(), 
					context
				)
			if context["tile_type"] == "building":
				self.picker_panel.load_list(
					self.editor.map.templates._building_templates.keys(), 
					context
				)
			if context["tile_type"] not in ["decoration","damage","frame","terrain","ground","building"]:
				self.picker_panel.load_list(
					self.editor.map.templates._ground_templates.keys() + self.editor.map.templates._damage_templates.keys() + self.editor.map.templates._frame_templates.keys() + self.editor.map.templates._decoration_templates.keys() + self.editor.map.templates._railway_templates.keys() + self.editor.map.templates._city_decoration_templates.keys() + self.editor.map.templates._city_templates.keys() + self.editor.map.templates._damaged_city_templates.keys() + self.editor.map.templates._wall_templates.keys() + self.editor.map.templates._nature_templates.keys() + self.editor.map.templates._special_templates.keys(), 
					context
				)
		_switch_to_panel(self.picker_panel)	

func _handle_picker_response(response, context):
	if context["tab"] == "settings":
		self.map_settings_panel._handle_picker_response(response, context)
		_switch_to_panel(self.map_settings_panel)	
	if context["tab"] == "triggers":
		self.triggers_panel._handle_picker_response(response, context)
		_switch_to_panel(self.triggers_panel)
	if context["tab"] == "stories":
		self.stories_panel._handle_picker_response(response, context)
		_switch_to_panel(self.stories_panel)

func _on_picker_value_selected(response, context):
	_handle_picker_response(response, context)
