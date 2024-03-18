extends Node
class_name GamepadAdapterClass

const DEADZONE: float = 0.5
const MOVEMENT_AXIS_X: JoyAxis = JOY_AXIS_LEFT_X
const MOVEMENT_AXIS_Y: JoyAxis = JOY_AXIS_LEFT_Y

const UI_UP: String = "ui_up"
const UI_DOWN: String = "ui_down"
const UI_LEFT: String = "ui_left"
const UI_RIGHT: String = "ui_right"

const BUTTON_INITIAL_INTERVAL: int = 500
const BUTTON_INTERVAL: int = 300


var state: Dictionary = {}
var device_id: int = 0


var enabled: bool = false
var ticks: int = 0

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
	var directions: Array[String] = [self.UI_UP, self.UI_DOWN, self.UI_LEFT, self.UI_RIGHT]

	for direction: String in directions:
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
	var axis_value: Vector2 = Vector2()

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
	for direction: String in self.state.keys():
		self.state[direction]["delay"] += delta * 1000

func handle_direction(direction: String) -> void:
	if self.state[direction]["pressed"]:
		self.state[direction]["pressed"] = false
		self.emit_event(direction, false)
		return

	var step_delay: int = self.BUTTON_INTERVAL
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

	var ev: InputEventAction = InputEventAction.new()
	ev.set_action(direction)
	ev.set_pressed(pressed)
	Input.parse_input_event(ev)

