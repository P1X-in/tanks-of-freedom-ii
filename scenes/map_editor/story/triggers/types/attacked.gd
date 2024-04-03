extends BaseTriggerTypeEditor

func fill_trigger_data(new_trigger_name, new_trigger_data):
	super.fill_trigger_data(new_trigger_name, new_trigger_data)
	
	$"vip/x".set_text("")
	$"vip/y".set_text("")
	
	if self.trigger_data.has("details"):
		if self.trigger_data["details"].has("vip"):
			$"vip/x".set_text(str(self.trigger_data["details"]["vip"][0]))
			$"vip/y".set_text(str(self.trigger_data["details"]["vip"][1]))

func _compile_trigger_data():
	var x = $"vip/x".get_text()
	var y = $"vip/y".get_text()

	self.trigger_data["details"] = {}

	if x != "" and y != "":
		self.trigger_data["details"]["vip"] = [int(x), int(y)]

	return self.trigger_data

func _on_text_changed(_new_text):
	_emit_updated_signal()

func _on_picker_button_pressed():
	self.audio.play("menu_click")

	var vip_position = null
	if self.trigger_data["details"].has("vip"):
		vip_position = self.trigger_data["details"]["vip"]

	self.picker_requested.emit({
		"tab": "settings",
		"type": "position",
		"position": vip_position,
		"trigger_name": self.trigger_name
	})

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "position":
		$"vip/x".set_text(str(response.x))
		$"vip/y".set_text(str(response.y))
		_emit_updated_signal()
