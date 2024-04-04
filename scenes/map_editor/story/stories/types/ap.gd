extends BaseStepActionEditor

var set_amount = false
var cap_amount = false

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"player_side/side".set_text("")
	$"amount/amount".set_text("0")
	$"set/set_button/label".set_text("TR_OFF")
	$"cap/cap_button/label".set_text("TR_OFF")
	
	if self.step_data.has("details"):
		if self.step_data["details"].has("side"):
			$"player_side/side".set_text(self.step_data["details"]["side"])
		
		if self.step_data["details"].has("amount"):
			$"amount/amount".set_text(str(self.step_data["details"]["amount"]))
			
		if self.step_data["details"].has("set"):
			self.set_amount = self.step_data["details"]["set"]
			if self.set_amount:
				$"set/set_button/label".set_text("TR_ON")
			else:
				$"set/set_button/label".set_text("TR_OFF")
		if self.step_data["details"].has("cap"):
			self.cap_amount = self.step_data["details"]["cap"]
			if self.cap_amount:
				$"cap/cap_button/label".set_text("TR_ON")
			else:
				$"cap/cap_button/label".set_text("TR_OFF")


func build_step_label(requested_step_data):
	var label = requested_step_data["action"]
	if requested_step_data.has("details"):
		if requested_step_data["details"].has("side"):
			label += " " + requested_step_data["details"]["side"]
	return label

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var player_side = $"player_side/side".get_text()
	var amount = $"amount/amount".get_text()

	self.step_data["details"] = {}

	if player_side != "":
		self.step_data["details"]["side"] = player_side
	if amount != "":
		self.step_data["details"]["amount"] = int(amount)

	self.step_data["details"]["set"] = self.set_amount
	self.step_data["details"]["cap"] = self.cap_amount

	return self.step_data

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "side":
		$"player_side/side".set_text(response)
	_emit_updated_signal()


func _on_side_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "side",
		"step_no": self.step_no
	})

func _on_set_button_pressed():
	self.audio.play("menu_click")
	self.set_amount = not self.set_amount
	if self.set_amount:
		$"set/set_button/label".set_text("TR_ON")
	else:
		$"set/set_button/label".set_text("TR_OFF")
	_emit_updated_signal()


func _on_cap_button_pressed():
	self.audio.play("menu_click")
	self.cap_amount = not self.cap_amount
	if self.cap_amount:
		$"cap/cap_button/label".set_text("TR_ON")
	else:
		$"cap/cap_button/label".set_text("TR_OFF")
	_emit_updated_signal()
