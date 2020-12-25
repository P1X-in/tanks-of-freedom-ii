extends Spatial

const DEADZONE = 0.2
const MOVEMENT_AXIS_X = JOY_ANALOG_LX
const MOVEMENT_AXIS_Y = JOY_ANALOG_LY
const CAMERA_AXIS_X = JOY_ANALOG_RX
const CAMERA_AXIS_Y = JOY_ANALOG_RY
const CAMERA_AXIS_ZOOM_IN = JOY_ANALOG_L2
const CAMERA_AXIS_ZOOM_OUT = JOY_ANALOG_R2


const MODE_FREE = "free"
const MODE_TOF = "tof"
const MODE_AW = "aw"

export var device_id = 0
export var rotate_speed = 100
export var zoom_speed = 20
export var move_speed = 50
export var camera_min_deg = -70
export var camera_max_deg = -15
export var camera_distance_min = 5
export var camera_distance_max = 35

export var tof_camera_distance_min = 25
export var tof_camera_distance_max = 50

export var aw_camera_distance_min = 25
export var aw_camera_distance_max = 50

export var camera_space_size = 100

var camera_mode = "tof"

var camera_pivot
var camera_arm
var camera_lens
var camera_tof
var camera_aw

var camera_angle_y = 0
var _camera_angle_y = 0

var camera_angle_x = 0
var _camera_angle_x = 0

var camera_distance = 0
var _camera_distance = 0

var tof_camera_distance = 0
var _tof_camera_distance = 0

var aw_camera_distance = 0
var _aw_camera_distance = 0

var paused = false

var reset_stick = false

func _ready():
    self.camera_pivot = $"pivot"
    self.camera_arm = $"pivot/arm"
    self.camera_lens = $"pivot/arm/lens"
    self.camera_tof = $"tof_pivot/tof_arm/tof_style_camera"
    self.camera_aw = $"aw_pivot/aw_arm/aw_style_camera"

    var rotation = self.camera_pivot.get_rotation_degrees()
    camera_angle_y = rotation.y
    _camera_angle_y = rotation.y

    rotation = self.camera_arm.get_rotation_degrees()
    camera_angle_x = rotation.x
    _camera_angle_x = rotation.x

    rotation = self.camera_lens.get_translation()
    camera_distance = rotation.z
    _camera_distance = rotation.z

    rotation = self.camera_tof.get_translation()
    tof_camera_distance = rotation.z
    _tof_camera_distance = rotation.z

    rotation = self.camera_aw.get_translation()
    aw_camera_distance = rotation.z
    _aw_camera_distance = rotation.z

func _input(event):
    if self.paused:
        return

    if event.is_action_pressed("switch_camera"):
        self.switch_camera()

func _process(_delta):
    if self.paused:
        return

    if camera_angle_y != _camera_angle_y:
        _camera_angle_y = camera_angle_y

        self.camera_pivot.set_rotation_degrees(Vector3(0, _camera_angle_y, 0))

    if camera_angle_x != _camera_angle_x:
        _camera_angle_x = camera_angle_x

        self.camera_arm.set_rotation_degrees(Vector3(_camera_angle_x, 0, 0))

    if camera_distance != _camera_distance:
        _camera_distance = camera_distance

        self.camera_lens.set_translation(Vector3(0, 0, _camera_distance))

    if tof_camera_distance != _tof_camera_distance:
        _tof_camera_distance = tof_camera_distance

        self.camera_tof.set_translation(Vector3(0, 0, _tof_camera_distance))
        self.camera_tof.set_size(0.8 * _tof_camera_distance)

    if aw_camera_distance != _aw_camera_distance:
        _aw_camera_distance = aw_camera_distance

        self.camera_aw.set_translation(Vector3(0, 0, _aw_camera_distance))
        self.camera_aw.set_size(0.8 * _aw_camera_distance)


func _physics_process(delta):
    if self.paused:
        return
        
    self.process_free_camera_input(delta)
    self.process_tof_camera_input(delta)
    self.process_aw_camera_input(delta)
    self.process_movement_input(delta)

func process_free_camera_input(delta):
    if self.camera_mode != self.MODE_FREE:
        return

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

func process_tof_camera_input(delta):
    if self.camera_mode != self.MODE_TOF:
        return

    var zoom_value = Vector2()
    zoom_value.x = Input.get_joy_axis(self.device_id, CAMERA_AXIS_ZOOM_IN)
    zoom_value.y = Input.get_joy_axis(self.device_id, CAMERA_AXIS_ZOOM_OUT)

    if abs(zoom_value.x) > DEADZONE:
        zoom_value.y = 0.0
        tof_camera_distance += self.zoom_speed * -zoom_value.x * delta
        tof_camera_distance = clamp(tof_camera_distance, self.tof_camera_distance_min, self.tof_camera_distance_max)

    if abs(zoom_value.y) > DEADZONE:
        tof_camera_distance += self.zoom_speed * zoom_value.y * delta
        tof_camera_distance = clamp(tof_camera_distance, self.tof_camera_distance_min, self.tof_camera_distance_max)

func process_aw_camera_input(delta):
    if self.camera_mode != self.MODE_AW:
        return

    var zoom_value = Vector2()
    zoom_value.x = Input.get_joy_axis(self.device_id, CAMERA_AXIS_ZOOM_IN)
    zoom_value.y = Input.get_joy_axis(self.device_id, CAMERA_AXIS_ZOOM_OUT)

    if abs(zoom_value.x) > DEADZONE:
        zoom_value.y = 0.0
        aw_camera_distance += self.zoom_speed * -zoom_value.x * delta
        aw_camera_distance = clamp(aw_camera_distance, self.aw_camera_distance_min, self.aw_camera_distance_max)

    if abs(zoom_value.y) > DEADZONE:
        aw_camera_distance += self.zoom_speed * zoom_value.y * delta
        aw_camera_distance = clamp(aw_camera_distance, self.aw_camera_distance_min, self.aw_camera_distance_max)

func process_movement_input(delta):
    var axis_value = Vector2()

    axis_value.x = -Input.get_joy_axis(self.device_id, MOVEMENT_AXIS_X)
    axis_value.y = -Input.get_joy_axis(self.device_id, MOVEMENT_AXIS_Y)

    if self.camera_mode == self.MODE_FREE:
        axis_value = axis_value.rotated(deg2rad(-self.camera_angle_y))
    if self.camera_mode == self.MODE_TOF:
        axis_value = axis_value.rotated(deg2rad(-45))
    if self.camera_mode == self.MODE_AW:
        axis_value = axis_value.rotated(deg2rad(0))

    if axis_value.length() > self.DEADZONE && not self.reset_stick:
        var position = self.get_translation()
        position.x -= axis_value.x * self.move_speed * delta
        position.z -= axis_value.y * self.move_speed * delta

        position.x = clamp(position.x, 0, self.camera_space_size)
        position.z = clamp(position.z, 0, self.camera_space_size)

        self.set_translation(position)
    elif axis_value.length() < self.DEADZONE && self.reset_stick:
        self.reset_stick = false
        

func switch_camera():
    if self.camera_mode == self.MODE_TOF:
        self.camera_mode = self.MODE_AW
        self.camera_aw.make_current()
        return
    if self.camera_mode == self.MODE_AW:
        self.camera_mode = self.MODE_FREE
        self.camera_lens.make_current()
        return
    if self.camera_mode == self.MODE_FREE:
        self.camera_mode = self.MODE_TOF
        self.camera_tof.make_current()
        return

func force_stick_reset():
    self.reset_stick = true
