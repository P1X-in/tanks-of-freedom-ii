extends Control
class_name BaseTriggerTypeEditor

var trigger_name
var trigger_data

@onready var audio = $"/root/SimpleAudioLibrary"

signal trigger_data_updated(trigger_name, trigger_data)
signal trigger_removal_requested(trigger_name)
signal story_select_requested(trigger_name)

func show_panel():
	self.show()

func fill_trigger_data(new_trigger_name, new_trigger_data):
	self.trigger_name = new_trigger_name
	self.trigger_data = new_trigger_data
	
	if not self.trigger_data.has("one_off"):
		self.trigger_data["one_off"] = false
	
	$"name".set_text(self.trigger_name)
	$"type".set_text(self.trigger_data["type"])
	
	if self.trigger_data["story"] != null:
		$"story".set_text(self.trigger_data["story"])
	else:
		$"story".set_text("")
	
	if self.trigger_data["one_off"]:
		$"oneoff_button/label".set_text("TR_ON")
	else:
		$"oneoff_button/label".set_text("TR_OFF")

func _emit_updated_signal():
	self.trigger_data_updated.emit(self.trigger_name, _compile_trigger_data())

func _compile_trigger_data():
	return self.trigger_data


func _on_delete_button_pressed():
	self.audio.play("menu_click")
	self.trigger_removal_requested.emit(self.trigger_name)


func _on_change_button_pressed():
	self.audio.play("menu_click")
	self.trigger_data["type"] = null
	_emit_updated_signal()


func _on_story_button_pressed():
	self.audio.play("menu_click")
	self.story_select_requested.emit(self.trigger_name)


func _on_oneoff_button_pressed():
	self.audio.play("menu_click")
	self.trigger_data["one_off"] = not self.trigger_data["one_off"]
	if self.trigger_data["one_off"]:
		$"oneoff_button/label".set_text("TR_ON")
	else:
		$"oneoff_button/label".set_text("TR_OFF")
