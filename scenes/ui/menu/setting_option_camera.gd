extends Control

onready var audio = $"/root/SimpleAudioLibrary"
onready var settings = $"/root/Settings"

onready var label = $"label"
onready var button = $"toggle"

export var option_name = ""
export var option_key = ""

func _ready():
    self.label.set_text(self.option_name)
    self._read_setting()

func _read_setting():
    var value = self.settings.get_option(self.option_key)

    if value != null:
        self.button.set_text(value)

func _on_toggle_button_pressed():
    var value = self.settings.get_option(self.option_key)

    if value == "TOF":
        value = "AW"
    elif value == "AW":
        value = "FREE"
    elif value == "FREE" or value == null:
        value = "TOF"

    self.settings.set_option(self.option_key, value)
    self.audio.play("menu_click")
    self._read_setting()
