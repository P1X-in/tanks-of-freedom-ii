extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"who/x".set_text("")
	$"who/y".set_text("")
	$"where/x".set_text("")
	$"where/y".set_text("")
	$"path/path".set_text("")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("who"):
			$"who/x".set_text(str(self.step_data["details"]["who"][0]))
			$"who/y".set_text(str(self.step_data["details"]["who"][1]))
		if self.step_data["details"].has("where"):
			$"where/x".set_text(str(self.step_data["details"]["where"][0]))
			$"where/y".set_text(str(self.step_data["details"]["where"][1]))

		if self.step_data["details"].has("path"):
			$"path/path".set_text(",".join(self.step_data["details"]["path"]))

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var x1 = $"who/x".get_text()
	var y1 = $"who/y".get_text()
	var x2 = $"where/x".get_text()
	var y2 = $"where/y".get_text()
	var path = Array($"path/path".get_text().split(","))

	self.step_data["details"] = {}

	if x1 != "" and y1 != "":
		self.step_data["details"]["who"] = [int(x1), int(y1)]
	if x2 != "" and y2 != "":
		self.step_data["details"]["where"] = [int(x2), int(y2)]

	if path.size() > 0:
		self.step_data["details"]["path"] = path

	return self.step_data

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "position":
		if context.has("field_id"):
			if context["field_id"] == "who":
				_handle_picker_response_for_fields($"who/x", $"who/y", response)
			if context["field_id"] == "where":
				_handle_picker_response_for_fields($"where/x", $"where/y", response)
	if context["type"] == "side":
		$"player_side/side".set_text(response)


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
