extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"trigger/trigger".set_text("")
	$"group/group".set_text("")
	$"trigger_action/trigger_action".set_text("")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("name"):
			$"trigger/trigger".set_text(self.step_data["details"]["name"])

		if self.step_data["details"].has("group"):
			$"group/group".set_text(self.step_data["details"]["group"])
		if self.step_data["details"].has("action"):
			$"trigger_action/trigger_action".set_text(str(self.step_data["details"]["action"]))

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var trigger = $"trigger/trigger".get_text()
	var group = $"group/group".get_text()
	var trigger_action = $"trigger_action/trigger_action".get_text()

	self.step_data["details"] = {}

	if trigger != "":
		self.step_data["details"]["name"] = trigger
	if group != "":
		self.step_data["details"]["group"] = group
	if trigger_action != "":
		self.step_data["details"]["action"] = trigger_action

	return self.step_data


func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "trigger":
		$"trigger/trigger".set_text(response)
	_emit_updated_signal()


func _on_trigger_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "trigger",
		"step_no": self.step_no
	})
