extends BaseTriggerTypeEditor

func fill_trigger_data(new_trigger_name, new_trigger_data):
	super.fill_trigger_data(new_trigger_name, new_trigger_data)
	
	$"player_id/id".set_text("")
	$"player_side/side".set_text("")
	$"amount/amount".set_text("1")
	
	if self.trigger_data.has("details"):
		if self.trigger_data["details"].has("player"):
			$"player_id/id".set_text(str(self.trigger_data["details"]["player"]))

		if self.trigger_data["details"].has("player_side"):
			$"player_side/side".set_text(self.trigger_data["details"]["player_side"])
			
		if self.trigger_data["details"].has("amount"):
			$"amount/amount".set_text(str(self.trigger_data["details"]["amount"]))

func _compile_trigger_data():
	var player_id = $"player_id/id".get_text()
	var player_side = $"player_side/side".get_text()
	var amount = $"amount/amount".get_text()

	self.trigger_data["details"] = {}

	if player_id != "":
		self.trigger_data["details"]["player"] = int(player_id)
	if player_side != "":
		self.trigger_data["details"]["player_side"] = player_side
	if amount != "":
		self.trigger_data["details"]["amount"] = int(amount)

	return self.trigger_data

func _on_text_changed(_new_text):
	_emit_updated_signal()

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "side":
		$"player_side/side".set_text(response)
	_emit_updated_signal()

func _on_side_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "side",
		"trigger_name": self.trigger_name
	})
