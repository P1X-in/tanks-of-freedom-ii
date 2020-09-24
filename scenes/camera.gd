extends Spatial

const DEADZONE = 0.2
const MOVEMENT_AXIS_X = JOY_ANALOG_LX
const MOVEMENT_AXIS_Y = JOY_ANALOG_LY
const CAMERA_AXIS_X = JOY_ANALOG_RX
const CAMERA_AXIS_Y = JOY_ANALOG_RY
const CAMERA_AXIS_ZOOM_IN = JOY_ANALOG_L2
const CAMERA_AXIS_ZOOM_OUT = JOY_ANALOG_R2

export var device_id = 0
export var rotate_speed = 100
export var zoom_speed = 20
export var move_speed = 50
export var camera_min_deg = -70
export var camera_max_deg = -15
export var camera_distance_min = 5
export var camera_distance_max = 35

var camera_pivot
var camera_arm
var camera_lens

var camera_angle_y = 0
var _camera_angle_y = 0

var camera_angle_x = 0
var _camera_angle_x = 0

var camera_distance = 0
var _camera_distance = 0


func _ready():
	self.camera_pivot = $"pivot"
	self.camera_arm = $"pivot/arm"
	self.camera_lens = $"pivot/arm/lens"

	var rotation = self.camera_pivot.get_rotation_degrees()
	camera_angle_y = rotation.y
	_camera_angle_y = rotation.y

	rotation = self.camera_arm.get_rotation_degrees()
	camera_angle_x = rotation.x
	_camera_angle_x = rotation.x

	rotation = self.camera_lens.get_translation()
	camera_distance = rotation.z
	_camera_distance = rotation.z


func _process(delta):
	if camera_angle_y != _camera_angle_y:
		_camera_angle_y = camera_angle_y

		self.camera_pivot.set_rotation_degrees(Vector3(0, _camera_angle_y, 0))

	if camera_angle_x != _camera_angle_x:
		_camera_angle_x = camera_angle_x

		self.camera_arm.set_rotation_degrees(Vector3(_camera_angle_x, 0, 0))

	if camera_distance != _camera_distance:
		_camera_distance = camera_distance

		self.camera_lens.set_translation(Vector3(0, 0, _camera_distance))


func _physics_process(delta):
	self.process_camera_input(delta)
	self.process_movement_input(delta)

func process_camera_input(delta):
	var axis_value = Vector2()

	axis_value.x = Input.get_joy_axis(self.device_id, CAMERA_AXIS_X)
	axis_value.y = Input.get_joy_axis(self.device_id, CAMERA_AXIS_Y)

	var zoom_value = Vector2()
	zoom_value.x = Input.get_joy_axis(self.device_id, CAMERA_AXIS_ZOOM_IN)
	zoom_value.y = Input.get_joy_axis(self.device_id, CAMERA_AXIS_ZOOM_OUT)

	if abs(axis_value.x) > DEADZONE:
		camera_angle_y -= self.rotate_speed * axis_value.x * delta

	if abs(axis_value.y) > DEADZONE:
	   camera_angle_x += self.rotate_speed * axis_value.y * delta
	   camera_angle_x = clamp(camera_angle_x, self.camera_min_deg, self.camera_max_deg)

	if abs(zoom_value.x) > DEADZONE:
		zoom_value.y = 0.0
		camera_distance += self.zoom_speed * -zoom_value.x * delta
		camera_distance = clamp(camera_distance, self.camera_distance_min, self.camera_distance_max)

	if abs(zoom_value.y) > DEADZONE:
		camera_distance += self.zoom_speed * zoom_value.y * delta
		camera_distance = clamp(camera_distance, self.camera_distance_min, self.camera_distance_max)

func process_movement_input(delta):
	var axis_value = Vector2()

	axis_value.x = -Input.get_joy_axis(self.device_id, MOVEMENT_AXIS_X)
	axis_value.y = -Input.get_joy_axis(self.device_id, MOVEMENT_AXIS_Y)
	axis_value = axis_value.rotated(deg2rad(-self.camera_angle_y))

	if axis_value.length() > self.DEADZONE:
		var position = self.get_translation()
		position.x -= axis_value.x * self.move_speed * delta
		position.z -= axis_value.y * self.move_speed * delta
		self.set_translation(position)
