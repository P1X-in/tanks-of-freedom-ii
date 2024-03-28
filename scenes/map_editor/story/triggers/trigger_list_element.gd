extends Control

signal edit_requested(trigger_name)

var trigger_name = null

func set_trigger_name(new_trigger_name):
	self.trigger_name = new_trigger_name
	$"Label".set_text(new_trigger_name)


func _on_edit_button_pressed():
	self.edit_requested.emit(self.trigger_name)
