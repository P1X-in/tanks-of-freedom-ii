extends Node2D

var editor

@onready var map_settings_button = $"widgets/tabs/map_settings_button"
@onready var audio = $"/root/SimpleAudioLibrary"

@onready var map_settings_panel = $"widgets/panels/MapSettings"


func show_panel():
	self.show()
	self.map_settings_button.grab_focus()
	_switch_to_panel(self.map_settings_panel)


func _switch_to_panel(panel):
	self.map_settings_panel.hide()
	panel.show_panel()

func ingest_map_data(metadata, _triggers, _stories):
	self.map_settings_panel.ingest_metadata(metadata)

func fill_metadata(metadata):
	return self.map_settings_panel.fill_metadata(metadata)

func fill_triggers(triggers):
	return triggers

func fill_stories(stories):
	return stories

func _on_map_settings_button_pressed():
	self.audio.play("menu_click")
	_switch_to_panel(self.map_settings_panel)


func _on_triggers_button_pressed():
	self.audio.play("menu_click")


func _on_stories_button_pressed():
	self.audio.play("menu_click")


func _on_back_button_pressed():
	self.audio.play("menu_back")
	if self.editor != null:
		self.editor.close_story()
