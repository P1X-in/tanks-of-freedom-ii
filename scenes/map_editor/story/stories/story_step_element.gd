extends Control

signal edit_requested(step_no)

var step_no = null

func set_step_name(new_step_no, label):
	self.step_no = new_step_no
	$"Label".set_text(str(new_step_no) + " - " + str(label))


func _on_edit_button_pressed():
	self.edit_requested.emit(self.step_no)
