extends Node

const DEADZONE := 0.5
const MOVEMENT_AXIS_X := JOY_AXIS_LEFT_X
const MOVEMENT_AXIS_Y := JOY_AXIS_LEFT_Y

const UI_UP := "ui_up"
const UI_DOWN := "ui_down"
const UI_LEFT := "ui_left"
const UI_RIGHT := "ui_right"

const BUTTON_INITIAL_INTERVAL := 500
const BUTTON_INTERVAL := 300


var state: Dictionary[String, Dictionary]= {}
var device_id := 0


var enabled := false
var ticks := 0

func _ready() -> void:
	self.disable()

func enable() -> void:
	self.enabled = true
	self.set_physics_process(true)

func disable() -> void:
	self.set_physics_process(false)
	self.enabled = false
	self.reset()

func reset() -> void:
	var directions := [self.UI_UP, self.UI_DOWN, self.UI_LEFT, self.UI_RIGHT]

	for direction in directions:
		self.state[direction] = {
			"pressed" : false,
			"delay" : 0
		}

func _physics_process(delta: float) -> void:
	if not get_window().has_focus():
		return

	if not self.enabled:
		return

	self.increment_directions(delta)
	var axis_value := Vector2()

	axis_value.x = Input.get_joy_axis(self.device_id, MOVEMENT_AXIS_X)
	axis_value.y = Input.get_joy_axis(self.device_id, MOVEMENT_AXIS_Y)

	if abs(axis_value.x) > self.DEADZONE:
		if axis_value.x > 0:
			self.handle_direction(self.UI_RIGHT)
		else:
			self.handle_direction(self.UI_LEFT)
	elif abs(axis_value.y) > self.DEADZONE:
		if axis_value.y > 0:
			self.handle_direction(self.UI_DOWN)
		else:
			self.handle_direction(self.UI_UP)
	else:
		self.increment_directions(self.BUTTON_INTERVAL)
		self.ticks = 0


func increment_directions(delta: float) -> void:
	for direction in self.state.keys():
		self.state[direction]["delay"] += delta * 1000

func handle_direction(direction: String) -> void:
	if self.state[direction]["pressed"]:
		self.state[direction]["pressed"] = false

		self.emit_event(direction, false)
		return

	var step_delay = self.BUTTON_INTERVAL
	if self.ticks > 1:
		@warning_ignore("integer_division")
		step_delay = step_delay / 2
	if self.state[direction]["delay"] > step_delay:
		self.state[direction]["pressed"] = true
		self.state[direction]["delay"] = 0

		self.emit_event(direction, true)
		self.ticks += 1

func emit_event(direction: String, pressed: bool) -> void:
	if pressed:
		Input.action_press(direction)
	else:
		Input.action_release(direction)

	var ev := InputEventAction.new()
	ev.set_action(direction)
	ev.set_pressed(pressed)
	Input.parse_input_event(ev)
