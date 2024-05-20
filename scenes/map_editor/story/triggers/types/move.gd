extends BaseTriggerTypeEditor

var current_index_vips = 0
var tmp_x = ""
var tmp_y = ""
var current_index_fields = 0
var tmp_x1 = ""
var tmp_x2 = ""
var tmp_y1 = ""
var tmp_y2 = ""

func fill_trigger_data(new_trigger_name, new_trigger_data):
	super.fill_trigger_data(new_trigger_name, new_trigger_data)
	
	$"player_id/id".set_text("")
	$"player_side/side".set_text("")
	$"vip/x".set_text("")
	$"vip/y".set_text("")
	$"unit_tag/tag".set_text("")
	$"excluded/x".set_text("")
	$"excluded/y".set_text("")
	$"fields/x1".set_text("")
	$"fields/y1".set_text("")
	$"fields/x2".set_text("")
	$"fields/y2".set_text("")
	
	self.current_index_vips = 0
	self.tmp_x = ""
	self.tmp_y = ""
	self.current_index_fields = 0
	self.tmp_x1 = ""
	self.tmp_x2 = ""
	self.tmp_y1 = ""
	self.tmp_y2 = ""
	
	if self.trigger_data.has("details"):
		if self.trigger_data["details"].has("player"):
			$"player_id/id".set_text(str(self.trigger_data["details"]["player"]) )

		if self.trigger_data["details"].has("player_side"):
			$"player_side/side".set_text(self.trigger_data["details"]["player_side"])

		if self.trigger_data["details"].has("unit"):
			$"vip/x".set_text(str(self.trigger_data["details"]["unit"][0]))
			$"vip/y".set_text(str(self.trigger_data["details"]["unit"][1]))
			
		if self.trigger_data["details"].has("unit_tag"):
			$"unit_tag/tag".set_text(str(self.trigger_data["details"]["unit_tag"]))
			
		if self.trigger_data["details"].has("excluded"):
			if self.trigger_data["details"]["excluded"].size() > 0:
				_fill_excluded_list_item(0)

		if self.trigger_data["details"].has("fields"):
			if self.trigger_data["details"]["fields"].size() > 0:
				_fill_fields_list_item(0)


func _fill_excluded_list_item(index):
	self.current_index_vips = index
	if index < self.trigger_data["details"]["excluded"].size():
		$"excluded/x".set_text(str(self.trigger_data["details"]["excluded"][index][0]))
		$"excluded/y".set_text(str(self.trigger_data["details"]["excluded"][index][1]))
	else:
		$"excluded/x".set_text(self.tmp_x)
		$"excluded/y".set_text(self.tmp_y)
	_manage_list_buttons()

func _fill_fields_list_item(index):
	self.current_index_fields = index
	if index < self.trigger_data["details"]["fields"].size():
		$"fields/x1".set_text(str(self.trigger_data["details"]["fields"][index]["x1"]))
		$"fields/y1".set_text(str(self.trigger_data["details"]["fields"][index]["y1"]))
		$"fields/x2".set_text(str(self.trigger_data["details"]["fields"][index]["x2"]))
		$"fields/y2".set_text(str(self.trigger_data["details"]["fields"][index]["y2"]))
	else:
		$"fields/x1".set_text(self.tmp_x1)
		$"fields/y1".set_text(self.tmp_y1)
		$"fields/x2".set_text(self.tmp_x2)
		$"fields/y2".set_text(self.tmp_y2)
	_manage_list_buttons()


func _compile_trigger_data():
	var current_excluded_list = []
	if self.trigger_data.has("details") and self.trigger_data["details"].has("excluded"):
		current_excluded_list = self.trigger_data["details"]["excluded"]
	var current_fields_list = []
	if self.trigger_data.has("details") and self.trigger_data["details"].has("fields"):
		current_fields_list = self.trigger_data["details"]["fields"]
	
	var vx = $"vip/x".get_text()
	var vy = $"vip/y".get_text()
	var player_id = $"player_id/id".get_text()
	var player_side = $"player_side/side".get_text()
	var unit_tag = $"unit_tag/tag".get_text()
	
	
	var x = $"excluded/x".get_text()
	var y = $"excluded/y".get_text()

	var x1 = $"fields/x1".get_text()
	var y1 = $"fields/y1".get_text()
	var x2 = $"fields/x2".get_text()
	var y2 = $"fields/y2".get_text()

	self.trigger_data["details"] = {}

	if player_id != "":
		self.trigger_data["details"]["player"] = int(player_id)
	if player_side != "":
		self.trigger_data["details"]["player_side"] = player_side
	if unit_tag != "":
		self.trigger_data["details"]["unit_tag"] = unit_tag

	if vx != "" and vy != "":
		self.trigger_data["details"]["unit"] = [int(vx), int(vy)]
	
	self.trigger_data["details"]["excluded"] = current_excluded_list
	if x != "" and y != "":
		if self.current_index_vips == self.trigger_data["details"]["excluded"].size():
			self.tmp_x = ""
			self.tmp_y = ""
			self.trigger_data["details"]["excluded"].append([int(x), int(y)])
		self.trigger_data["details"]["excluded"][self.current_index_vips] = [int(x), int(y)]
		_manage_list_buttons()
	else:
		if self.current_index_vips == self.trigger_data["details"]["excluded"].size():
			self.tmp_x = x
			self.tmp_y = y


	self.trigger_data["details"]["fields"] = current_fields_list
	if x1 != "" and y1 != "" and x2 != "" and y2 != "":
		if self.current_index_fields == self.trigger_data["details"]["fields"].size():
			self.tmp_x1 = ""
			self.tmp_y1 = ""
			self.tmp_x2 = ""
			self.tmp_y2 = ""
			self.trigger_data["details"]["fields"].append({"x1": int(x1), "y1": int(y1), "x2": int(x2), "y2": int(y2)})
		self.trigger_data["details"]["fields"][self.current_index_fields] = {"x1": int(x1), "y1": int(y1), "x2": int(x2), "y2": int(y2)}
		_manage_list_buttons()
	else:
		if self.current_index_fields == self.trigger_data["details"]["fields"].size():
			self.tmp_x1 = x1
			self.tmp_y1 = y1
			self.tmp_x2 = x2
			self.tmp_y2 = y2

	return self.trigger_data

func _on_text_changed(_new_text):
	_emit_updated_signal()

func _manage_list_buttons():
	var excluded_size = 0
	if self.trigger_data["details"].has("excluded"):
		excluded_size = self.trigger_data["details"]["excluded"].size()
	$"excluded/no".set_text(str(self.current_index_vips + 1) + "/" + str(excluded_size))
	if self.current_index_vips > 0:
		$"excluded/prev_button".show()
	else:
		$"excluded/prev_button".hide()
	if self.current_index_vips < excluded_size:
		$"excluded/next_button".show()
	else:
		$"excluded/next_button".hide()

	var fields_size = 0
	if self.trigger_data["details"].has("fields"):
		fields_size = self.trigger_data["details"]["fields"].size()
	$"fields/no".set_text(str(self.current_index_fields + 1) + "/" + str(fields_size))
	if self.current_index_fields > 0:
		$"fields/prev_button".show()
	else:
		$"fields/prev_button".hide()
	if self.current_index_fields < fields_size:
		$"fields/next_button".show()
	else:
		$"fields/next_button".hide()


func _handle_excluded_element_removal():
	var x = $"excluded/x".get_text()
	var y = $"excluded/y".get_text()
	
	var excluded_size = 0
	if self.trigger_data["details"].has("excluded"):
		excluded_size = self.trigger_data["details"]["excluded"].size()
		
	if x == "" or y == "":
		if self.current_index_vips < excluded_size:
			self.trigger_data["details"]["excluded"].pop_at(self.current_index_vips)
			return true
	return false

func _handle_fields_element_removal():
	var x1 = $"fields/x1".get_text()
	var y1 = $"fields/y1".get_text()
	var x2 = $"fields/x2".get_text()
	var y2 = $"fields/y2".get_text()
	
	var fields_size = 0
	if self.trigger_data["details"].has("fields"):
		fields_size = self.trigger_data["details"]["fields"].size()
		
	if x1 == "" or y1 == "" or x2 == "" or y2 == "":
		if self.current_index_fields < fields_size:
			self.trigger_data["details"]["fields"].pop_at(self.current_index_fields)
			return true
	return false

func _on_excluded_prev_button_pressed():
	self.audio.play("menu_click")
	_handle_excluded_element_removal()
	_fill_excluded_list_item(self.current_index_vips - 1)


func _on_excluded_next_button_pressed():
	self.audio.play("menu_click")
	if _handle_excluded_element_removal():
		_fill_excluded_list_item(self.current_index_vips)
	else:
		_fill_excluded_list_item(self.current_index_vips + 1)

func _on_fields_prev_button_pressed():
	self.audio.play("menu_click")
	_handle_fields_element_removal()
	_fill_fields_list_item(self.current_index_fields - 1)


func _on_fields_next_button_pressed():
	self.audio.play("menu_click")
	if _handle_fields_element_removal():
		_fill_fields_list_item(self.current_index_fields)
	else:
		_fill_fields_list_item(self.current_index_fields + 1)


func _on_vip_picker_button_pressed():
	self.audio.play("menu_click")
	_request_picker_for_fields("vip", $"vip/x", $"vip/y")


func _on_excluded_picker_button_pressed():
	self.audio.play("menu_click")
	_request_picker_for_fields("excluded", $"excluded/x", $"excluded/y")


func _on_fields_1_picker_button_pressed():
	self.audio.play("menu_click")
	_request_picker_for_fields("fields_1", $"fields/x1", $"fields/y1")


func _on_fields_2_picker_button_pressed():
	self.audio.play("menu_click")
	_request_picker_for_fields("fields_2", $"fields/x2", $"fields/y2")


func _request_picker_for_fields(identifier, input_x, input_y):
	var x = input_x.get_text()
	var y = input_y.get_text()

	var current_position = null
	if x != "" and y != "":
		current_position = [int(x), int(y)]

	self.picker_requested.emit({
		"type": "position",
		"position": current_position,
		"trigger_name": self.trigger_name,
		"field_id": identifier
	})

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "position":
		if context.has("field_id"):
			if context["field_id"] == "vip":
				_handle_picker_response_for_fields($"vip/x", $"vip/y", response)
			if context["field_id"] == "excluded":
				_handle_picker_response_for_fields($"excluded/x", $"excluded/y", response)
			if context["field_id"] == "fields_1":
				_handle_picker_response_for_fields($"fields/x1", $"fields/y1", response)
			if context["field_id"] == "fields_2":
				_handle_picker_response_for_fields($"fields/x2", $"fields/y2", response)
	if context["type"] == "side":
		$"player_side/side".set_text(response)


func _handle_picker_response_for_fields(input_x, input_y, response):
	input_x.set_text(str(response.x))
	input_y.set_text(str(response.y))
	_emit_updated_signal()


func _on_side_picker_button_pressed():
	self.audio.play("menu_click")

	self.picker_requested.emit({
		"type": "side",
		"trigger_name": self.trigger_name
	})
