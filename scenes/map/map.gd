extends Spatial

const TILE_SIZE = 8
const GROUND_HEIGHT = 4

onready var tile_box = $"tiles/tile_box"
onready var camera = $"camera"
onready var campaign = $"/root/Campaign"
onready var mouse_layer = $"/root/MouseLayer"
onready var settings = $"/root/Settings"

var tile_box_space_size
var tile_box_position = Vector2(0, 0)

var templates = preload("res://scenes/map/templates.gd").new()
var model = preload("res://scenes/map/model.gd").new()
var builder = preload("res://scenes/map/builder.gd").new(self)
var loader = preload("res://scenes/map/loader.gd").new(self)

onready var tiles_ground_anchor = $"tiles/ground"
onready var tiles_frames_anchor = $"tiles/frames"
onready var tiles_terrain_anchor = $"tiles/terrain"
onready var tiles_buildings_anchor = $"tiles/buildings"
onready var tiles_units_anchor = $"tiles/units"

func _ready():
    self.tile_box_space_size = self.camera.camera_space_size - self.TILE_SIZE

    if not self.settings.get_option("decorations"):
        self.tiles_frames_anchor.hide()


func _physics_process(_delta):
    self.update_tile_box_position_from_camera()
    self.snap_tile_box()


func update_tile_box_position_from_camera():
    if self.camera.snap_tile_box_to_camera:
        self.tile_box_position = self.world_to_map(self.camera.get_translation())

func set_tile_box_position(position):
    self.camera.snap_tile_box_to_camera = false
    self.tile_box_position = position


func snap_tile_box():
    var position = self.tile_box.get_translation()
    var placement = self.map_to_world(self.tile_box_position)

    placement.y = position.y

    self.tile_box.set_translation(placement)

func map_to_world(position):
    return Vector3(position.x * self.TILE_SIZE, 0, position.y * self.TILE_SIZE)

func world_to_map(position):
    var tile_position = Vector2(0, 0)

    if position.x == self.camera.camera_space_size:
        position.x = self.tile_box_space_size
    if position.z == self.camera.camera_space_size:
        position.z = self.tile_box_space_size

    var camera_position_x = int(position.x)
    var camera_position_z = int(position.z)

    tile_position.x = (camera_position_x - (camera_position_x % self.TILE_SIZE)) / self.TILE_SIZE
    tile_position.y = (camera_position_z - (camera_position_z % self.TILE_SIZE)) / self.TILE_SIZE

    return tile_position


func set_tile_box_side(side):
    self.tile_box.set_mesh_material(self.templates.get_side_material(side))

func show_tile_box():
    self.tile_box.show()

func hide_tile_box():
    self.tile_box.hide()

func move_camera_to_position(destination):
    if destination == null:
        return

    self.camera.move_camera_to_position(destination * self.TILE_SIZE + Vector2(0.5, 0.5) * self.TILE_SIZE)

func move_camera_to_position_if_far_away(destination, tolerance=5, zoom=null):
    if zoom != null:
        self.camera.set_camera_zoom(zoom)

    if destination == null:
        return false

    self.update_tile_box_position_from_camera()
    var adj_tol = tolerance * self.camera.get_zoom_fraction()
    if self.tile_box_position.distance_squared_to(destination) > (adj_tol * adj_tol) or zoom != null:
        self.move_camera_to_position(destination)

    return true

func snap_camera_to_position(destination):
    self.camera.set_camera_position(destination * self.TILE_SIZE + Vector2(0.5, 0.5) * self.TILE_SIZE)

func anchor_unit(unit, position):
    var world_position = self.map_to_world(position)
    world_position.y = self.GROUND_HEIGHT
    self.tiles_units_anchor.add_child(unit)
    unit.set_translation(world_position)
    

func detach_unit(unit):
    self.tiles_units_anchor.remove_child(unit)

func hide_invisible_tiles():
    for i in self.model.tiles.keys():
        self.model.tiles[i].apply_invisibility()
