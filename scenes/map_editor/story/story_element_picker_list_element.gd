extends Control

signal value_selected(element_value)

var element_value = null

func set_element_value(new_element_value):
	self.element_value = new_element_value
	$"button/label".set_text(new_element_value)


func _on_button_pressed():
	self.value_selected.emit(self.element_value)
