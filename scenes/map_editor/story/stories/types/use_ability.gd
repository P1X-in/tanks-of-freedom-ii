extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"who/x".set_text("")
	$"who/y".set_text("")
	$"which/which".set_text("")
	$"where/x".set_text("")
	$"where/y".set_text("")
	$"cooldown/cooldown_button/label".set_text("TR_OFF")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("who"):
			$"who/x".set_text(str(self.step_data["details"]["who"][0]))
			$"who/y".set_text(str(self.step_data["details"]["who"][1]))

		if self.step_data["details"].has("which"):
			$"which/which".set_text(self.step_data["details"]["which"])

		if self.step_data["details"].has("where"):
			$"where/x".set_text(str(self.step_data["details"]["where"][0]))
			$"where/y".set_text(str(self.step_data["details"]["where"][1]))

		if self.step_data["details"].has("cooldown"):
			if self.step_data["details"]["cooldown"]:
				$"cooldown/cooldown_button/label".set_text("TR_ON")
			else:
				$"cooldown/cooldown_button/label".set_text("TR_OFF")

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var x1 = $"who/x".get_text()
	var y1 = $"who/y".get_text()
	var which = $"which/which".get_text()
	var x2 = $"where/x".get_text()
	var y2 = $"where/y".get_text()
	var cooldown = false

	if self.step_data["details"].has("cooldown"):
		cooldown = self.step_data["details"]["cooldown"]

	self.step_data["details"] = {
		"cooldown": cooldown
	}

	if x1 != "" and y1 != "":
		self.step_data["details"]["who"] = [int(x1), int(y1)]
	if which != "":
		self.step_data["details"]["which"] = which
	if x2 != "" and y2 != "":
		self.step_data["details"]["where"] = [int(x2), int(y2)]

	return self.step_data

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "position":
		if context.has("field_id"):
			if context["field_id"] == "who":
				_handle_picker_response_for_fields($"who/x", $"who/y", response)
			if context["field_id"] == "where":
				_handle_picker_response_for_fields($"where/x", $"where/y", response)


func _handle_picker_response_for_fields(input_x, input_y, response):
	input_x.set_text(str(response.x))
	input_y.set_text(str(response.y))
	_emit_updated_signal()


func _on_who_picker_button_pressed():
	_request_picker_for_fields("who", $"who/x", $"who/y")


func _on_where_picker_button_pressed():
	_request_picker_for_fields("where", $"where/x", $"where/y")

func _request_picker_for_fields(identifier, input_x, input_y):
	var x = input_x.get_text()
	var y = input_y.get_text()

	var current_position = null
	if x != "" and y != "":
		current_position = [int(x), int(y)]

	self.picker_requested.emit({
		"type": "position",
		"position": current_position,
		"step_no": self.step_no,
		"field_id": identifier
	})


func _on_cooldown_button_pressed():
	self.audio.play("menu_click")
	if not self.step_data["details"].has("cooldown"):
		self.step_data["details"]["cooldown"] = false
	self.step_data["details"]["cooldown"] = not self.step_data["details"]["cooldown"]
	if self.step_data["details"]["cooldown"]:
		$"cooldown/cooldown_button/label".set_text("TR_ON")
	else:
		$"cooldown/cooldown_button/label".set_text("TR_OFF")
	_emit_updated_signal()
