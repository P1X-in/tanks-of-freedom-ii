extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"vip/x".set_text("")
	$"vip/y".set_text("")
	$"length/length".set_text("")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("who"):
			$"vip/x".set_text(str(self.step_data["details"]["who"][0]))
			$"vip/y".set_text(str(self.step_data["details"]["who"][1]))

		if self.step_data["details"].has("length"):
			$"length/length".set_text(str(self.step_data["details"]["length"]))

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var x = $"vip/x".get_text()
	var y = $"vip/y".get_text()
	var length = $"length/length".get_text()

	self.step_data["details"] = {}

	if x != "" and y != "":
		self.step_data["details"]["who"] = [int(x), int(y)]
	if length != "":
		self.step_data["details"]["length"] = int(length)

	return self.step_data


func _on_picker_button_pressed():
	self.audio.play("menu_click")

	var vip_position = null
	if self.step_data["details"].has("who"):
		vip_position = self.step_data["details"]["who"]

	self.picker_requested.emit({
		"type": "position",
		"position": vip_position,
		"step_no": self.step_no
	})

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "position":
		$"vip/x".set_text(str(response.x))
		$"vip/y".set_text(str(response.y))
	_emit_updated_signal()
