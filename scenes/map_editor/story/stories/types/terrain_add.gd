extends BaseStepActionEditor

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"where/x".set_text("")
	$"where/y".set_text("")
	$"tile_type/tile_type".set_text("")
	$"template/template".set_text("")
	$"player_side/side".set_text("")
	$"rotation/rotation".set_text("")
	$"smoke/smoke_button/label".set_text("TR_OFF")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("where"):
			$"where/x".set_text(str(self.step_data["details"]["where"][0]))
			$"where/y".set_text(str(self.step_data["details"]["where"][1]))

		if self.step_data["details"].has("type"):
			$"tile_type/tile_type".set_text(self.step_data["details"]["type"])

		if self.step_data["details"].has("template"):
			$"template/template".set_text(self.step_data["details"]["template"])

		if self.step_data["details"].has("side"):
			$"player_side/side".set_text(self.step_data["details"]["side"])

		if self.step_data["details"].has("rotation"):
			$"rotation/rotation".set_text(str(self.step_data["details"]["rotation"]))

		if self.step_data["details"].has("smoke"):
			if self.step_data["details"]["smoke"]:
				$"smoke/smoke_button/label".set_text("TR_ON")
			else:
				$"smoke/smoke_button/label".set_text("TR_OFF")

func build_step_label(requested_step_data):
	var label = requested_step_data["action"]
	if requested_step_data.has("details"):
		if requested_step_data["details"].has("template"):
			label += " " + requested_step_data["details"]["template"]
	return label

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var x = $"where/x".get_text()
	var y = $"where/y".get_text()
	var tile_type = $"tile_type/tile_type".get_text()
	var template = $"template/template".get_text()
	var player_side = $"player_side/side".get_text()
	var unit_rotation = $"rotation/rotation".get_text()
	var smoke = false

	if self.step_data["details"].has("smoke"):
		smoke = self.step_data["details"]["smoke"]

	self.step_data["details"] = {
		"smoke": smoke
	}

	if x != "" and y != "":
		self.step_data["details"]["where"] = [int(x), int(y)]
	if tile_type != "":
		self.step_data["details"]["type"] = tile_type
	if template != "":
		self.step_data["details"]["template"] = template
	if player_side != "":
		self.step_data["details"]["side"] = player_side
	if unit_rotation != "":
		self.step_data["details"]["rotation"] = int(unit_rotation)

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

func _on_side_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "side",
		"step_no": self.step_no
	})

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "position":
		$"where/x".set_text(str(response.x))
		$"where/y".set_text(str(response.y))
	if context["type"] == "tile_type":
		$"tile_type/tile_type".set_text(response)
	if context["type"] == "template":
		$"template/template".set_text(response)
	if context["type"] == "side":
		$"player_side/side".set_text(response)
	_emit_updated_signal()


func _on_type_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "tile_type",
		"step_no": self.step_no
	})


func _on_template_picker_button_pressed():
	self.audio.play("menu_click")
	
	var type = ""
	if self.step_data["details"].has("type"):
		type =  self.step_data["details"]["type"]
	self.picker_requested.emit({
		"type": "template",
		"tile_type": type,
		"step_no": self.step_no
	})


func _on_smoke_button_pressed():
	self.audio.play("menu_click")
	if not self.step_data["details"].has("smoke"):
		self.step_data["details"]["smoke"] = false
	self.step_data["details"]["smoke"] = not self.step_data["details"]["smoke"]
	if self.step_data["details"]["smoke"]:
		$"smoke/smoke_button/label".set_text("TR_ON")
	else:
		$"smoke/smoke_button/label".set_text("TR_OFF")
	_emit_updated_signal()
