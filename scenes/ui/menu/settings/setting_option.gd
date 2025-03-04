extends Control


signal help_requested(tip: String)
signal clear_help_requested()


@onready var audio = $"/root/SimpleAudioLibrary"
@onready var settings = $"/root/Settings"

@onready var label = $"label"
@onready var button = $"toggle"
@onready var button_label = $"toggle/label"

@export var unavailable = false
@export var option_name = ""
@export var option_key = ""
@export var help_tip = ""

func _ready():
	self.label.set_text(self.option_name)
	self._read_setting()
	self.button.set_disabled(self.unavailable)

func _read_setting():
	var value = self.settings.get_option(self.option_key)

	match value:
		null:
			self.button_label.set_text("???")
			self.button.set_disabled(true)
		true:
			self.button_label.set_text("TR_ON")
		false:
			self.button_label.set_text("TR_OFF")

func _on_toggle_button_pressed():
	self.settings.set_option(self.option_key, not self.settings.get_option(self.option_key))
	self.audio.play("menu_click")
	self._read_setting()


func _show_help():
	if self.help_tip != "":
		help_requested.emit(help_tip)
	else:
		self._clear_help()

func _clear_help():
	clear_help_requested.emit()
