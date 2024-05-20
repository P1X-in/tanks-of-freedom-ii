extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"player_side/side".set_text("")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("winner"):
			$"player_side/side".set_text(self.step_data["details"]["winner"])

func build_step_label(requested_step_data):
	var label = requested_step_data["action"]
	if requested_step_data.has("details"):
		if requested_step_data["details"].has("winner"):
			label += " " + requested_step_data["details"]["winner"]
	return label

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var player_side = $"player_side/side".get_text()

	self.step_data["details"] = {}

	if player_side != "":
		self.step_data["details"]["winner"] = player_side

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
