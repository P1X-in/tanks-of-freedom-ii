extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"name/name".set_text("")
	$"portrait/portrait".set_text("")
	$"actor_side/side_button/label".set_text("TR_LEFT")
	$"colour/colour".set_text("")
	$"font/font".set_text("")
	$"sound/sound".set_text("")
	$"text".set_text("")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("name"):
			$"name/name".set_text(self.step_data["details"]["name"])
		if self.step_data["details"].has("portrait"):
			$"portrait/portrait".set_text(self.step_data["details"]["portrait"])

		if self.step_data["details"].has("side"):
			if self.step_data["details"]["side"] == "left":
				$"actor_side/side_button/label".set_text("TR_LEFT")
			if self.step_data["details"]["side"] == "right":
				$"actor_side/side_button/label".set_text("TR_RIGHT")

		if self.step_data["details"].has("colour"):
			$"colour/colour".set_text(self.step_data["details"]["colour"])
		if self.step_data["details"].has("font"):
			$"font/font".set_text(str(self.step_data["details"]["font_size"]))
		if self.step_data["details"].has("sound"):
			$"sound/sound".set_text(self.step_data["details"]["sound"])
		if self.step_data["details"].has("text"):
			$"text".set_text(self.step_data["details"]["text"])



func build_step_label(requested_step_data):
	var label = requested_step_data["action"]
	if requested_step_data.has("details"):
		if requested_step_data["details"].has("name"):
			label += " " + requested_step_data["details"]["name"]
	return label

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var actor_name = $"name/name".get_text()
	var portrait = $"portrait/portrait".get_text()
	var actor_side = "left"
	var colour = $"colour/colour".get_text()
	var font = $"font/font".get_text()
	var sound = $"sound/sound".get_text()
	var text = $"text".get_text()

	if self.step_data["details"].has("side"):
		actor_side = self.step_data["details"]["side"]

	self.step_data["details"] = {
		"side": actor_side
	}

	if actor_name != "":
		self.step_data["details"]["name"] = actor_name
	if portrait != "":
		self.step_data["details"]["portrait"] = portrait
	if colour != "":
		self.step_data["details"]["colour"] = colour
	if font != "":
		self.step_data["details"]["font_size"] = int(font)
	if sound != "":
		self.step_data["details"]["sound"] = sound
	if text != "":
		self.step_data["details"]["text"] = text

	return self.step_data


func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "side":
		$"colour/colour".set_text(response)
	if context["type"] == "portrait":
		$"portrait/portrait".set_text(response)
	if context["type"] == "sound":
		$"sound/sound".set_text(response)
	_emit_updated_signal()


func _on_portrait_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "portrait",
		"step_no": self.step_no
	})


func _on_side_button_pressed():
	self.audio.play("menu_click")
	if not self.step_data["details"].has("side"):
		self.step_data["details"]["side"] = "left"

	if self.step_data["details"]["side"] == "left":
		self.step_data["details"]["side"] = "right"
		$"actor_side/side_button/label".set_text("TR_RIGHT")
	else:
		self.step_data["details"]["side"] = "left"
		$"actor_side/side_button/label".set_text("TR_LEFT")
	_emit_updated_signal()


func _on_colour_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "side",
		"step_no": self.step_no
	})


func _on_sound_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "sound",
		"step_no": self.step_no
	})


func _on_text_area_changed():
	_emit_updated_signal()
