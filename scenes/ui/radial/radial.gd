extends Node2D

signal close_requested


@onready var animations = $"animations"
@onready var label_node = $"label"
@onready var label_text = $"label/label"

@export var analog_axis_x = JOY_AXIS_LEFT_X
@export var analog_axis_y = JOY_AXIS_LEFT_Y
@export var device_id = 0

var fields = []
var focused_field = null

var mouse_mode = false
var opening = false

func _ready():
	self.fields = [
		$"fields/field1",
		$"fields/field2",
		$"fields/field3",
		$"fields/field4",
		$"fields/field5",
		$"fields/field6",
		$"fields/field7",
		$"fields/field8",
	]
	self.set_process_input(false)

	var index = 0
	while index < self.fields.size():
		self.fields[index].bind_radial(self, index)
		index += 1

func _input(event):
	if not get_window().has_focus():
		return

	var axis_value = Vector2()

	axis_value.x = Input.get_joy_axis(self.device_id, self.analog_axis_x)
	axis_value.y = Input.get_joy_axis(self.device_id, self.analog_axis_y)

	if axis_value.length() > 0.5:
		self.mouse_mode = false
		var angle = rad_to_deg(axis_value.angle()) + 112.5
		if angle < 0.0:
			angle += 360

		angle = int(round(angle))

		var option = (angle - (angle % 45)) / 45

		self.focus_field(option)

		if event.is_action_pressed("ui_accept"):
			self.execute_focused_field()

	else:
		if not self.mouse_mode:
			self.unfocus_field()

	if event.is_action_released("mouse_click"):
		if self.is_field_focused():
			self.execute_focused_field()
		else:
			self.close_requested.emit()

func show_menu():
	self.opening = true
	self.animations.play("show")
	self.set_process_input(true)

func _show_menu_done():
	self.opening = false
	self.set_process_input(true)
	

func hide_menu():
	self.animations.play("hide")
	self.set_process_input(false)
	self.unfocus_field()

func set_field(icon, new_label, index, new_bound_object=null, new_bound_method=null, new_bound_args=[]):
	self.fields[index].set_field(icon, new_label, new_bound_object, new_bound_method, new_bound_args)

func set_field_disabled(index, cooldown=null, ignore_disabled_state=false):
	self.fields[index].set_disabled(cooldown)
	self.fields[index].ignore_disabled = ignore_disabled_state

func clear_field_disabled(index):
	self.fields[index].clear_disabled()

func clear_fields():
	for field in self.fields:
		field.clear()

func clear_field(index):
	self.fields[index].clear()

func focus_field(index):
	if index >= self.fields.size():
		return
	if self.fields[index].focused:
		return

	self.unfocus_field()

	if not self.fields[index].is_assigned():
		return

	self.fields[index].focus()
	self.show_label(self.fields[index].label)
	self.focused_field = self.fields[index]

func unfocus_field():
	if self.focused_field != null:
		self.focused_field.unfocus()
	self.hide_label()
	self.focused_field = null

func show_label(new_label):
	self.label_node.show()
	self.label_text.set_text(new_label)

func hide_label():
	self.label_node.hide()

func is_field_focused():
	return self.focused_field != null

func execute_focused_field():
	if not self.is_field_focused():
		return

	if not self.is_visible():
		return

	SimpleAudioLibrary.play("menu_click")
	self.focused_field.execute_bound_method()
