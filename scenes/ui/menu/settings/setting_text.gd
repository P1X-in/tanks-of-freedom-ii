extends Control


signal help_requested(tip: String)
signal clear_help_requested()

@onready var audio = $"/root/SimpleAudioLibrary"
@onready var settings = $"/root/Settings"

@onready var label = $"label"
@onready var text_input = $"text"

@export var unavailable = false
@export var option_name = ""
@export var option_key = ""
@export var help_tip = ""
@export var placeholder = ""
@export var is_int = true

func _ready():
	self.label.set_text(self.option_name)
	self._read_setting()
	self.text_input.set_editable(not self.unavailable)
	self.text_input.set_placeholder(self.placeholder)

func _read_setting():
	var value = self.settings.get_option(self.option_key)

	self.text_input.set_text(str(value))

func _on_text_text_changed(_text):
	var new_value = self.text_input.get_text()
	if is_int:
		new_value = new_value.to_int()
	self.settings.set_option(self.option_key, new_value)
	self.audio.play("menu_click")


func _show_help():
	if self.help_tip != "":
		help_requested.emit(help_tip)
	else:
		self._clear_help()

func _clear_help():
	clear_help_requested.emit()

