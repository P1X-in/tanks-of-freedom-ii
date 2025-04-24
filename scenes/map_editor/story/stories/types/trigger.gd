extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"trigger/trigger".set_text("")
	$"suspended/suspended_button/label".set_text("TR_OFF")
	$"group/group".set_text("")
	$"turns/turns".set_text("")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("name"):
			$"trigger/trigger".set_text(self.step_data["details"]["name"])

		if self.step_data["details"].has("suspended"):
			if self.step_data["details"]["suspended"]:
				$"suspended/suspended_button/label".set_text("TR_ON")
			else:
				$"suspended/suspended_button/label".set_text("TR_OFF")

		if self.step_data["details"].has("group"):
			$"group/group".set_text(self.step_data["details"]["group"])
		if self.step_data["details"].has("turns"):
			$"turns/turns".set_text(str(self.step_data["details"]["turns"]))

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var trigger = $"trigger/trigger".get_text()
	var group = $"group/group".get_text()
	var turns = $"turns/turns".get_text()
	var suspended = false
	
	if not self.step_data.has("details"):
		self.step_data["details"] = {}

	if self.step_data["details"].has("suspended"):
		suspended = self.step_data["details"]["suspended"]

	self.step_data["details"] = {
		"suspended": suspended
	}

	if trigger != "":
		self.step_data["details"]["name"] = trigger
	if group != "":
		self.step_data["details"]["group"] = group
	if turns != "":
		self.step_data["details"]["turns"] = int(turns)

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


func _on_suspended_button_pressed():
	self.audio.play("menu_click")
	if not self.step_data.has("details"):
		self.step_data["details"] = {}
	if not self.step_data["details"].has("suspended"):
		self.step_data["details"]["suspended"] = false
	self.step_data["details"]["suspended"] = not self.step_data["details"]["suspended"]
	if self.step_data["details"]["suspended"]:
		$"suspended/suspended_button/label".set_text("TR_ON")
	else:
		$"suspended/suspended_button/label".set_text("TR_OFF")
	_emit_updated_signal()
