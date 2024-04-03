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


func _on_back_button_pressed():
	self.audio.play("menu_back")
	if self.picker_panel.is_visible():
		if self.picker_panel.picker_context["tab"] == "triggers":
			_switch_to_panel(self.triggers_panel)
		return
	if self.editor != null:
		self.editor.close_story()


func _on_picker_requested(context):
	if context["type"] == "position":
		self.picker_requested.emit(context)
	else:
		if context["type"] == "story":
			self.picker_panel.load_list(self.stories_panel._get_sorted_stories_names(), context)
		_switch_to_panel(self.picker_panel)	

func _handle_picker_response(response, context):
	if context["tab"] == "settings":
		self.map_settings_panel._handle_picker_response(response, context)
		_switch_to_panel(self.map_settings_panel)	
	if context["tab"] == "triggers":
		self.triggers_panel._handle_picker_response(response, context)
		_switch_to_panel(self.triggers_panel)

func _on_picker_value_selected(response, context):
	_handle_picker_response(response, context)
