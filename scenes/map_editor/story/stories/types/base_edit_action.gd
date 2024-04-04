extends Control
class_name BaseStepActionEditor

var step_no
var step_data

@onready var audio = $"/root/SimpleAudioLibrary"

signal step_data_updated(step_no, step_data)
signal step_move_requested(step_no, new_step_no)
signal step_removal_requested(step_no)
signal picker_requested(context)

func show_panel():
	self.show()

func fill_step_data(new_step_no, new_step_data):
	self.step_no = new_step_no
	self.step_data = new_step_data
	
	if not self.step_data.has("delay"):
		self.step_data["delay"] = 0
	
	$"delay/delay".set_text(str(self.step_data["delay"]))
	$"step_no/no".set_text(str(self.step_no))
	$"action".set_text(self.step_data["action"])

func build_step_label(requested_step_data):
	return requested_step_data["action"]

func _emit_updated_signal():
	self.step_data_updated.emit(self.step_no, _compile_step_data())

func _compile_step_data():
	var delay = $"delay/delay".get_text()

	if delay != "":
		self.step_data["delay"] = int(delay)

	return self.step_data


func _on_text_changed(_new_text):
	_emit_updated_signal()

func _on_delete_button_pressed():
	self.audio.play("menu_click")
	self.step_removal_requested.emit(self.step_no)


func _on_change_button_pressed():
	self.audio.play("menu_click")
	self.step_data["action"] = null
	_emit_updated_signal()


func _handle_picker_response(_response, _context):
	return


func _on_move_button_pressed():
	self.audio.play("menu_click")
	var new_step_no = $"step_no/no".get_text()
	if new_step_no != "":
		new_step_no = int(new_step_no)
		if self.step_no != new_step_no:
			self.step_move_requested.emit(self.step_no, new_step_no)
