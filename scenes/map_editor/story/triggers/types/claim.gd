extends BaseTriggerTypeEditor

var current_index = 0
var tmp_x = ""
var tmp_y = ""

func fill_trigger_data(new_trigger_name, new_trigger_data):
	super.fill_trigger_data(new_trigger_name, new_trigger_data)
	
	$"player_id/id".set_text("")
	$"player_side/side".set_text("")
	$"amount/amount".set_text("1")
	$"list/x".set_text("")
	$"list/y".set_text("")
	
	self.current_index = 0
	self.tmp_x = ""
	self.tmp_y = ""
	
	if self.trigger_data.has("details"):
		if self.trigger_data["details"].has("player"):
			$"player_id/id".set_text(str(self.trigger_data["details"]["player"]))

		if self.trigger_data["details"].has("player_side"):
			var side = self.trigger_data["details"]["player_side"]
			if side is Array:
				side = ",".join(side)
			$"player_side/side".set_text(side)
			
		if self.trigger_data["details"].has("amount"):
			$"amount/amount".set_text(str(self.trigger_data["details"]["amount"]))
			
		if self.trigger_data["details"].has("list"):
			if self.trigger_data["details"]["list"].size() > 0:
				_fill_list_item(0)
	_manage_list_buttons()


func _fill_list_item(index):
	var list_size = 0
	if self.trigger_data["details"].has("list"):
		list_size = self.trigger_data["details"]["list"].size()
		
	self.current_index = index
	if index < list_size:
		$"list/x".set_text(str(self.trigger_data["details"]["list"][index][0]))
		$"list/y".set_text(str(self.trigger_data["details"]["list"][index][1]))
	else:
		$"list/x".set_text(self.tmp_x)
		$"list/y".set_text(self.tmp_y)
	_manage_list_buttons()

func _compile_trigger_data():
	var current_list = []
	if self.trigger_data.has("details") and self.trigger_data["details"].has("list"):
		current_list = self.trigger_data["details"]["list"]
	
	var player_id = $"player_id/id".get_text()
	var player_side = Array($"player_side/side".get_text().split(","))
	var amount = $"amount/amount".get_text()
	
	
	var x = $"list/x".get_text()
	var y = $"list/y".get_text()

	self.trigger_data["details"] = {}

	if player_id != "":
		self.trigger_data["details"]["player"] = int(player_id)
	if player_side.size() > 0:
		if self.trigger_data["type"] == null:
			self.trigger_data["details"]["player_side"] = $"player_side/side".get_text()
		else:
			self.trigger_data["details"]["player_side"] = player_side
	if amount != "":
		self.trigger_data["details"]["amount"] = int(amount)
	
	self.trigger_data["details"]["list"] = current_list
	if x != "" and y != "":
		if self.current_index == self.trigger_data["details"]["list"].size():
			self.tmp_x = ""
			self.tmp_y = ""
			self.trigger_data["details"]["list"].append([int(x), int(y)])
		self.trigger_data["details"]["list"][self.current_index] = [int(x), int(y)]
		_manage_list_buttons()
	else:
		if self.current_index == self.trigger_data["details"]["list"].size():
			self.tmp_x = x
			self.tmp_y = y

	return self.trigger_data

func _on_text_changed(_new_text):
	_emit_updated_signal()

func _manage_list_buttons():
	var list_size = 0
	if self.trigger_data["details"].has("list"):
		list_size = self.trigger_data["details"]["list"].size()
	$"list/no".set_text(str(self.current_index + 1) + "/" + str(list_size))
	if self.current_index > 0:
		$"list/prev_button".show()
	else:
		$"list/prev_button".hide()
	if self.current_index < list_size:
		$"list/next_button".show()
	else:
		$"list/next_button".hide()


func _handle_element_removal():
	var x = $"list/x".get_text()
	var y = $"list/y".get_text()
	
	var list_size = 0
	if self.trigger_data["details"].has("list"):
		list_size = self.trigger_data["details"]["list"].size()
	
	if x == "" or y == "":
		if self.current_index < list_size:
			self.trigger_data["details"]["list"].pop_at(self.current_index)
			return true
	return false

func _on_prev_button_pressed():
	self.audio.play("menu_click")
	_handle_element_removal()
	_fill_list_item(self.current_index - 1)


func _on_next_button_pressed():
	self.audio.play("menu_click")
	if _handle_element_removal():
		_fill_list_item(self.current_index)
	else:
		_fill_list_item(self.current_index + 1)


func _on_picker_button_pressed():
	self.audio.play("menu_click")

	var x = $"list/x".get_text()
	var y = $"list/y".get_text()

	var building_position = null
	if x != "" and y != "":
		building_position = [int(x), int(y)]

	self.picker_requested.emit({
		"tab": "settings",
		"type": "position",
		"position": building_position,
		"trigger_name": self.trigger_name
	})

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "position":
		$"list/x".set_text(str(response.x))
		$"list/y".set_text(str(response.y))
		_emit_updated_signal()
