extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"player_side/side".set_text("")
	$"ban/ban_button/label".set_text("TR_OFF")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("side"):
			$"player_side/side".set_text(self.step_data["details"]["side"])

		if self.step_data["details"].has("suspended"):
			if self.step_data["details"]["suspended"]:
				$"ban/ban_button/label".set_text("TR_ON")
			else:
				$"ban/ban_button/label".set_text("TR_OFF")

func build_step_label(requested_step_data):
	var label = requested_step_data["action"]
	if requested_step_data.has("details"):
		if requested_step_data["details"].has("side"):
			label += " " + requested_step_data["details"]["side"]
	return label

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var player_side = $"player_side/side".get_text()
	var ban = false

	if self.step_data["details"].has("suspended"):
		ban = self.step_data["details"]["suspended"]

	self.step_data["details"] = {
		"suspended": ban
	}

	if player_side != "":
		self.step_data["details"]["side"] = player_side

	return self.step_data


func _on_side_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "side",
		"step_no": self.step_no
	})

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "side":
		$"player_side/side".set_text(response)
	_emit_updated_signal()

func _on_ban_button_pressed():
	self.audio.play("menu_click")
	if not self.step_data["details"].has("suspended"):
		self.step_data["details"]["suspended"] = false
	self.step_data["details"]["suspended"] = not self.step_data["details"]["suspended"]
	if self.step_data["details"]["suspended"]:
		$"ban/ban_button/label".set_text("TR_ON")
	else:
		$"ban/ban_button/label".set_text("TR_OFF")
	_emit_updated_signal()
	
