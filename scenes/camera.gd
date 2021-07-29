extends Spatial

const DEADZONE = 0.2
const MOVEMENT_AXIS_X = JOY_ANALOG_LX
const MOVEMENT_AXIS_Y = JOY_ANALOG_LY
const CAMERA_AXIS_X = JOY_ANALOG_RX
const CAMERA_AXIS_Y = JOY_ANALOG_RY
const CAMERA_AXIS_ZOOM_IN = JOY_ANALOG_L2
const CAMERA_AXIS_ZOOM_OUT = JOY_ANALOG_R2
const SHAKE_MAX_MAGNITUDE = 0.5
const MOUSE_MOVE_THRESHOLD = 16


const MODE_FREE = "free"
const MODE_TOF = "tof"
const MODE_AW = "aw"

export var device_id = 0
export var rotate_speed = 100
export var zoom_speed = 20
export var move_speed = 50
export var mouse_zoom_step = 2.0
export var camera_auto_pan_follow_speed = 9.0
export var camera_auto_pan_speed_modifier = 1.5
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
var ai_operated = false
var script_operated = false

var reset_stick = false

var camera_start = null
var camera_destination = null
var camera_transit_time = 0.0
var camera_in_transit = false
var camera_zoom_start = null
var camera_tof_zoom_start = null
var camera_aw_zoom_start = null
var camera_zoom_fraction = null

var shakes_left = 0
var last_shake_time = 0

var snap_tile_box_to_camera = true
var mouse_drag = false
var mouse_click_position = null

func _ready():
    randomize()
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
    if event.is_action_pressed("mouse_zoom_in"):
        self._mouse_zoom_in()
    if event.is_action_pressed("mouse_zoom_out"):
        self._mouse_zoom_out()

    if self.camera_in_transit or self.ai_operated or self.script_operated:
        return

    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
        if event.pressed:
            self.mouse_click_position = event.position
        else:
            self.mouse_click_position = null
    elif event is InputEventMouseMotion:
        if self.mouse_click_position != null:
            if event.position.distance_squared_to(self.mouse_click_position) > self.MOUSE_MOVE_THRESHOLD:
                self.mouse_drag = true
        else:
            self.mouse_drag = false

        if self.mouse_drag:
            self._mouse_shift_camera(event.relative)

func _process(delta):
    if self.paused:
        return

    if self.camera_destination != null:
        self.pan_camera(delta)

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

    self._perform_shake(delta)

    self.process_free_camera_input(delta)
    self.process_tof_camera_input(delta)
    self.process_aw_camera_input(delta)

    if self.camera_in_transit or self.ai_operated or self.script_operated:
        return

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

    if camera_angle_y > 360.0:
        camera_angle_y -= 360.0
    if camera_angle_y < 0.0:
        camera_angle_y += 360.0

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
        self.snap_tile_box_to_camera = true
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

func move_camera_to_position(destination):
    var camera_position = self.get_translation()

    self.camera_start = Vector2(camera_position.x, camera_position.z)
    self.camera_destination = destination
    self.camera_transit_time = 0.0
    self.camera_in_transit = true

func set_camera_position(position):
    var current_position = self.get_translation()
    current_position.x = position.x
    current_position.z = position.y

    self.set_translation(current_position)

func pan_camera(delta):
    self.camera_transit_time += delta * self.camera_auto_pan_speed_modifier

    var transit_time = self.camera_transit_time
    if transit_time > 1.0:
        transit_time = 1.0

    var interpolated_position = self.camera_start.linear_interpolate(self.camera_destination, transit_time)

    var camera_position = self.get_translation()
    var camera_position_2d = Vector2(camera_position.x, camera_position.z)
    var smooth_position = camera_position_2d.linear_interpolate(interpolated_position, delta * self.camera_auto_pan_follow_speed)

    camera_position.x = smooth_position.x
    camera_position.z = smooth_position.y

    self.set_translation(camera_position)

    if self.camera_zoom_fraction != null:
        self.camera_distance = self.camera_zoom_start + (self.camera_distance_min + (self.camera_distance_max - self.camera_distance_min) * self.camera_zoom_fraction - self.camera_zoom_start) * transit_time
        self.tof_camera_distance = self.camera_tof_zoom_start + (self.tof_camera_distance_min + (self.tof_camera_distance_max - self.tof_camera_distance_min) * self.camera_zoom_fraction - self.camera_tof_zoom_start) * transit_time
        self.aw_camera_distance = self.camera_aw_zoom_start + (self.aw_camera_distance_min + (self.aw_camera_distance_max - self.aw_camera_distance_min) * self.camera_zoom_fraction - self.camera_aw_zoom_start) * transit_time

    if self.camera_transit_time >= 1.5:
        self.camera_start = null
        self.camera_destination = null
        self.camera_transit_time = 0.0
        self.camera_in_transit = false
        self.camera_zoom_start = null
        self.camera_tof_zoom_start = null
        self.camera_aw_zoom_start = null
        self.camera_zoom_fraction = null

func set_camera_zoom(fraction):
    self.camera_zoom_start = _camera_distance
    self.camera_tof_zoom_start = _tof_camera_distance
    self.camera_aw_zoom_start = _aw_camera_distance
    self.camera_zoom_fraction = fraction

    return

func shake():
    self.shakes_left = 3
    self.last_shake_time = 900.0

func _perform_shake(delta):
    var shake_offset = Vector2(0, 0)
    self.last_shake_time += delta

    if self.last_shake_time > 0.04:
        self.last_shake_time = 0.0
        if self.shakes_left > 0:
            self.shakes_left -= 1
            shake_offset.x = self.SHAKE_MAX_MAGNITUDE * rand_range(-1, 1)
            shake_offset.y = self.SHAKE_MAX_MAGNITUDE * rand_range(-1, 1)

        self._set_camera_translation(self.camera_lens, shake_offset)
        self._set_camera_translation(self.camera_tof, shake_offset)
        self._set_camera_translation(self.camera_aw, shake_offset)


func _set_camera_translation(camera, offset):
    var translation = camera.get_translation()
    translation.x = offset.x
    translation.y = offset.y
    camera.set_translation(translation)

func _shift_camera_translation(offset):
    var current_position = self.get_translation()
    current_position.x += offset.x
    current_position.z += offset.y

    self.set_translation(current_position)

func _mouse_zoom_in():
    camera_distance -= self.mouse_zoom_step
    camera_distance = clamp(camera_distance, self.camera_distance_min, self.camera_distance_max)

    tof_camera_distance -= self.mouse_zoom_step
    tof_camera_distance = clamp(tof_camera_distance, self.tof_camera_distance_min, self.tof_camera_distance_max)

    aw_camera_distance -= self.mouse_zoom_step
    aw_camera_distance = clamp(aw_camera_distance, self.aw_camera_distance_min, self.aw_camera_distance_max)


func _mouse_zoom_out():
    camera_distance += self.mouse_zoom_step
    camera_distance = clamp(camera_distance, self.camera_distance_min, self.camera_distance_max)

    tof_camera_distance += self.mouse_zoom_step
    tof_camera_distance = clamp(tof_camera_distance, self.tof_camera_distance_min, self.tof_camera_distance_max)

    aw_camera_distance += self.mouse_zoom_step
    aw_camera_distance = clamp(aw_camera_distance, self.aw_camera_distance_min, self.aw_camera_distance_max)

func _mouse_shift_camera(relative_offset):
    var camera_fraction
    if self.camera_mode == self.MODE_TOF:
        camera_fraction = self.tof_camera_distance / self.tof_camera_distance_max
        relative_offset = relative_offset * camera_fraction * Vector2(0.08, 0.16)
        relative_offset = relative_offset.rotated(deg2rad(-45))
    if self.camera_mode == self.MODE_AW:
        camera_fraction = self.aw_camera_distance / self.aw_camera_distance_max
        relative_offset = relative_offset * camera_fraction * Vector2(0.08, 0.12)
    if self.camera_mode == self.MODE_FREE:
        camera_fraction = self.camera_distance / self.camera_distance_max
        relative_offset = relative_offset * camera_fraction * 0.08
        relative_offset = relative_offset.rotated(deg2rad(-self.camera_angle_y))

    self._shift_camera_translation(-relative_offset)

