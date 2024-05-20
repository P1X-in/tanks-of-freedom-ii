extends Control

var step_no
var step_data

@onready var audio = $"/root/SimpleAudioLibrary"

signal step_data_updated(step_no, step_data)
signal step_move_requested(step_no, new_step_no)
signal step_removal_requested(step_no)
signal picker_requested(context)

func _ready():
	for button in $"buttons".get_children():
		button.pressed.connect(self._on_type_pressed.bind(button))
		
func show_panel():
	self.show()

func _on_type_pressed(button):
	self.audio.play("menu_click")
	self.step_data["action"] = str(button.name)
	self.step_data_updated.emit(self.step_no, self.step_data)


func fill_step_data(new_step_no, new_step_data):
	self.step_no = new_step_no
	self.step_data = new_step_data
