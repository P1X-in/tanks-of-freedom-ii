extends Control

var trigger_name
var trigger_data

@onready var audio = $"/root/SimpleAudioLibrary"

signal trigger_data_updated(trigger_name, trigger_data)
signal trigger_removal_requested(trigger_name)
signal picker_requested(context)

func _ready():
	for button in $"buttons".get_children():
		button.pressed.connect(self._on_type_pressed.bind(button))
		
func show_panel():
	self.show()

func _on_type_pressed(button):
	self.audio.play("menu_click")
	self.trigger_data["type"] = str(button.name)
	self.trigger_data_updated.emit(self.trigger_name, self.trigger_data)


func fill_trigger_data(new_trigger_name, new_trigger_data):
	self.trigger_name = new_trigger_name
	self.trigger_data = new_trigger_data
