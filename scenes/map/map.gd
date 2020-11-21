extends Spatial

const TILE_SIZE = 8
const GROUND_HEIGHT = 4

onready var tile_box = $"tiles/tile_box"
onready var camera = $"camera"

var tile_box_space_size
var camera_tile_position = Vector2(0, 0)

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


func _physics_process(_delta):
    self.update_camera_tile_position()
    self.snap_tile_box()


func update_camera_tile_position():
    self.camera_tile_position = self.world_to_map(self.camera.get_translation())


func snap_tile_box():
    var position = self.tile_box.get_translation()
    var placement = self.map_to_world(self.camera_tile_position)

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

