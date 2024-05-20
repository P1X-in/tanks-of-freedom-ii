extends BaseStepActionEditor

var current_index_fields = 0
var tmp_x1 = ""
var tmp_x2 = ""
var tmp_y1 = ""
var tmp_y2 = ""

func fill_step_data(new_step_no, new_step_data):
	super.fill_step_data(new_step_no, new_step_data)
	
	$"vip/x".set_text("")
	$"vip/y".set_text("")
	$"fields/x1".set_text("")
	$"fields/y1".set_text("")
	$"fields/x2".set_text("")
	$"fields/y2".set_text("")
	
	self.current_index_fields = 0
	self.tmp_x1 = ""
	self.tmp_x2 = ""
	self.tmp_y1 = ""
	self.tmp_y2 = ""

	if self.step_data.has("details"):
		if self.step_data["details"].has("who"):
			$"vip/x".set_text(str(self.step_data["details"]["who"][0]))
			$"vip/y".set_text(str(self.step_data["details"]["who"][1]))

		if self.step_data["details"].has("fields"):
			if self.step_data["details"]["fields"].size() > 0:
				_fill_fields_list_item(0)

func _compile_step_data():
	self.step_data = super._compile_step_data()
	
	var current_fields_list = []
	if self.step_data.has("details") and self.step_data["details"].has("fields"):
		current_fields_list = self.step_data["details"]["fields"]

	var x = $"vip/x".get_text()
	var y = $"vip/y".get_text()

	var x1 = $"fields/x1".get_text()
	var y1 = $"fields/y1".get_text()
	var x2 = $"fields/x2".get_text()
	var y2 = $"fields/y2".get_text()

	self.step_data["details"] = {}

	if x != "" and y != "":
		self.step_data["details"]["who"] = [int(x), int(y)]

	self.step_data["details"]["fields"] = current_fields_list
	if x1 != "" and y1 != "" and x2 != "" and y2 != "":
		if self.current_index_fields == self.step_data["details"]["fields"].size():
			self.tmp_x1 = ""
			self.tmp_y1 = ""
			self.tmp_x2 = ""
			self.tmp_y2 = ""
			self.step_data["details"]["fields"].append({"x1": int(x1), "y1": int(y1), "x2": int(x2), "y2": int(y2)})
		self.step_data["details"]["fields"][self.current_index_fields] = {"x1": int(x1), "y1": int(y1), "x2": int(x2), "y2": int(y2)}
		_manage_list_buttons()
	else:
		if self.current_index_fields == self.step_data["details"]["fields"].size():
			self.tmp_x1 = x1
			self.tmp_y1 = y1
			self.tmp_x2 = x2
			self.tmp_y2 = y2

	return self.step_data


func _on_picker_button_pressed():
	self.audio.play("menu_click")
	_request_picker_for_fields("who", $"vip/x", $"vip/y")

func _handle_picker_response(response, context):
	super._handle_picker_response(response, context)
	if context["type"] == "position":
		if context.has("field_id"):
			if context["field_id"] == "who":
				_handle_picker_response_for_fields($"vip/x", $"vip/y", response)
			if context["field_id"] == "fileds_1":
				_handle_picker_response_for_fields($"fields/x1", $"fields/y1", response)
			if context["field_id"] == "fileds_2":
				_handle_picker_response_for_fields($"fields/x2", $"fields/y2", response)
	_emit_updated_signal()

func _handle_picker_response_for_fields(input_x, input_y, response):
	input_x.set_text(str(response.x))
	input_y.set_text(str(response.y))
	_emit_updated_signal()

func _handle_fields_element_removal():
	var x1 = $"fields/x1".get_text()
	var y1 = $"fields/y1".get_text()
	var x2 = $"fields/x2".get_text()
	var y2 = $"fields/y2".get_text()
	
	var fields_size = 0
	if self.step_data["details"].has("fields"):
		fields_size = self.step_data["details"]["fields"].size()
		
	if x1 == "" or y1 == "" or x2 == "" or y2 == "":
		if self.current_index_fields < fields_size:
			self.step_data["details"]["fields"].pop_at(self.current_index_fields)
			return true
	return false
	
func _on_prev_button_pressed():
	self.audio.play("menu_click")
	_handle_fields_element_removal()
	_fill_fields_list_item(self.current_index_fields - 1)


func _on_next_button_pressed():
	self.audio.play("menu_click")
	if _handle_fields_element_removal():
		_fill_fields_list_item(self.current_index_fields)
	else:
		_fill_fields_list_item(self.current_index_fields + 1)


func _on_fields_1_picker_button_pressed():
	self.audio.play("menu_click")
	_request_picker_for_fields("fileds_1", $"fields/x1", $"fields/y1")


func _on_fields_2_picker_button_pressed():
	self.audio.play("menu_click")
	_request_picker_for_fields("fileds_2", $"fields/x2", $"fields/y2")

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


func _fill_fields_list_item(index):
	self.current_index_fields = index
	if index < self.step_data["details"]["fields"].size():
		$"fields/x1".set_text(str(self.step_data["details"]["fields"][index]["x1"]))
		$"fields/y1".set_text(str(self.step_data["details"]["fields"][index]["y1"]))
		$"fields/x2".set_text(str(self.step_data["details"]["fields"][index]["x2"]))
		$"fields/y2".set_text(str(self.step_data["details"]["fields"][index]["y2"]))
	else:
		$"fields/x1".set_text(self.tmp_x1)
		$"fields/y1".set_text(self.tmp_y1)
		$"fields/x2".set_text(self.tmp_x2)
		$"fields/y2".set_text(self.tmp_y2)
	_manage_list_buttons()

func _manage_list_buttons():
	var fields_size = 0
	if self.step_data["details"].has("fields"):
		fields_size = self.step_data["details"]["fields"].size()
	$"fields/no".set_text(str(self.current_index_fields + 1) + "/" + str(fields_size))
	if self.current_index_fields > 0:
		$"fields/prev_button".show()
	else:
		$"fields/prev_button".hide()
	if self.current_index_fields < fields_size:
		$"fields/next_button".show()
	else:
		$"fields/next_button".hide()
