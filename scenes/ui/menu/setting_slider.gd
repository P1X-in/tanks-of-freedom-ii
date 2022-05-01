extends Control

onready var audio = $"/root/SimpleAudioLibrary"
onready var settings = $"/root/Settings"

onready var label = $"label"
onready var slider_value = $"slider_value"
onready var slider = $"slider"

export var option_name = "name"
export var option_key = "key"

var ready = false

func _ready():
    self.label.set_text(self.option_name)
    self._read_setting()
    self.ready = true

func _read_setting():
    var value = self.settings.get_option(self.option_key)

    self.slider_value.set_text(str(value))
    self.slider.set_value(value)


func _on_slider_value_changed(value):
    self.settings.set_option(self.option_key, int(value))
    if self.ready:
        self.audio.play("menu_click")
    self.slider_value.set_text(str(int(value)))
    
