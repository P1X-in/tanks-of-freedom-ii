extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"where/x".set_text("")
	$"where/y".set_text("")
	$"ability/id".set_text("")
	$"ban/ban_button/label".set_text("TR_OFF")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("where"):
			$"where/x".set_text(str(self.step_data["details"]["where"][0]))
			$"where/y".set_text(str(self.step_data["details"]["where"][1]))

		if self.step_data["details"].has("ability_id"):
			$"ability/id".set_text(str(self.step_data["details"]["ability_id"]))

		if self.step_data["details"].has("ban"):
			if self.step_data["details"]["ban"]:
				$"ban/ban_button/label".set_text("TR_ON")
			else:
				$"ban/ban_button/label".set_text("TR_OFF")

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var x = $"where/x".get_text()
	var y = $"where/y".get_text()
	var ability_id = $"ability/id".get_text()
	var ban = false

	if self.step_data["details"].has("ban"):
		ban = self.step_data["details"]["ban"]

	self.step_data["details"] = {
		"ban": ban
	}

	if x != "" and y != "":
		self.step_data["details"]["where"] = [int(x), int(y)]
	if ability_id != "":
		self.step_data["details"]["ability_id"] = int(ability_id)

	return self.step_data


func _on_picker_button_pressed():
	self.audio.play("menu_click")

	var vip_position = null
	if self.step_data["details"].has("where"):
		vip_position = self.step_data["details"]["where"]

	self.picker_requested.emit({
		"type": "position",
		"position": vip_position,
		"step_no": self.step_no
	})

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "position":
		$"where/x".set_text(str(response.x))
		$"where/y".set_text(str(response.y))
	_emit_updated_signal()


func _on_ban_button_pressed():
	self.audio.play("menu_click")
	if not self.step_data["details"].has("ban"):
		self.step_data["details"]["ban"] = false
	self.step_data["details"]["ban"] = not self.step_data["details"]["ban"]
	if self.step_data["details"]["ban"]:
		$"ban/ban_button/label".set_text("TR_ON")
	else:
		$"ban/ban_button/label".set_text("TR_OFF")
	_emit_updated_signal()
