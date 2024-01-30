extends Control

@onready var audio = $"/root/SimpleAudioLibrary"
@onready var settings = $"/root/Settings"

@onready var label = $"label"
@onready var text_input = $"text"

@export var unavailable = false
@export var option_name = ""
@export var option_key = ""
@export var help_tip = ""
@export var placeholder = ""

func _ready():
	self.label.set_text(self.option_name)
	self._read_setting()
	self.text_input.set_editable(not self.unavailable)
	self.text_input.set_placeholder(self.placeholder)

func _read_setting():
	var value = self.settings.get_option(self.option_key)

	self.text_input.set_text(str(value))

func _on_text_text_changed(_text):
	self.settings.set_option(self.option_key, self.text_input.get_text().to_int())
	self.audio.play("menu_click")


func _show_help():
	if self.help_tip != "":
		self.get_parent().get_parent().get_parent().get_parent().show_help(self.help_tip)
	else:
		self._clear_help()

func _clear_help():
	self.get_parent().get_parent().get_parent().get_parent().hide_help()

