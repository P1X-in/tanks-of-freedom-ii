extends "res://scenes/tiles/tile.gd"

onready var animations = $"animations"

export var side = "neutral"
export var material_type = "normal"

export var max_hp = 10
var hp = 0
export var max_move = 4
var move = 0
export var attack = 7
export var armor = 2
export var can_capture = false
var attacks = 1

var modifiers = []

var unit_rotations = {
    "s" : 0,
    "n" : 180,
    "e" : 90,
    "w" : 270,
}
var unit_translations = {
    "n" : Vector3(0, 0, -8),
    "s" : Vector3(0, 0, 8),
    "e" : Vector3(8, 0, 0),
    "w" : Vector3(-8, 0, 0),
}
var current_path = []
var current_path_index = 0

func reset():
    self.hp = self.max_hp
    self.move = self.max_move
    self.attacks = 1

func get_dict():
    var new_dict = .get_dict()
    new_dict["side"] = self.side
    
    return new_dict
    
func set_side(new_side):
    self.side = new_side

func set_side_material(material):
    $"mesh_anchor/mesh".set_surface_material(0, material)

    var additional_mesh

    additional_mesh = self.get_node_or_null("mesh_anchor/mesh/mesh2")
    if additional_mesh != null:
        additional_mesh.set_surface_material(0, material)

    additional_mesh = self.get_node_or_null("mesh_anchor/mesh/mesh3")
    if additional_mesh != null:
        additional_mesh.set_surface_material(0, material)


func get_stats_with_modifiers():
    return {
        "hp" : self.hp,
        "move" : self.move,
        "attack" : self.attack,
        "armor" : self.armor,
    }

func get_move():
    var stats = self.get_stats_with_modifiers()
    return stats["move"]

func use_move(value):
    self.move -= value

func can_attack(_unit):
    return true

func has_attacks():
    return self.attacks > 0

func use_attack():
    self.attacks -= 1

func rotate_unit_to_direction(direction):
    var rotation = self.unit_rotations[direction]
    self.set_rotation(Vector3(0, deg2rad(rotation), 0))

func animate_path(path):
    self.current_path = path
    self.current_path_index = 0
    self._animate_initial_path_segment()

func _animate_initial_path_segment():
    var direction = self.current_path[self.current_path_index]
    self.move_in_direction(direction)

func _animate_next_path_segment():
    var direction = self.current_path[self.current_path_index]
    $"mesh_anchor".set_translation(Vector3(0, 0, 0))
    self.set_translation(self.get_translation() + self.unit_translations[direction])
    self.current_path_index += 1
    direction = self.current_path[self.current_path_index]
    self.move_in_direction(direction)

func move_in_direction(direction):
    self.rotate_unit_to_direction(direction)
    if self.current_path_index < self.current_path.size() - 1:
        self.animations.play("move")

func stop_animations():
    self.animations.stop()

