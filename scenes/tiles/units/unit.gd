extends "res://scenes/tiles/tile.gd"

onready var animations = $"animations"
onready var spotlight = $"mesh_anchor/activity_light"
onready var explosion = $"explosion"

export var side = "neutral"
export var material_type = "normal"

export var max_hp = 10
var hp = 0
export var max_move = 4
var move = 0
export var attack = 7
export var armor = 2
export var can_capture = false
export var can_fly = false
export var max_attacks = 1
export var uses_metallic_material = false
export var unit_value = 0
export var unit_class = ""
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

var move_finished_object = null
var move_finished_method = ""
var move_finished_args = []


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

    additional_mesh = self.get_node_or_null("mesh_anchor/mesh2")
    if additional_mesh != null:
        additional_mesh.set_surface_material(0, material)

    additional_mesh = self.get_node_or_null("mesh_anchor/mesh3")
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

func has_moves():
    return self.move > 0

func use_move(value):
    self.move -= value
    if self.move < 1:
        self.spotlight.hide()

func use_all_moves():
    self.use_move(self.move)

func reset_move():
    self.move = self.max_move
    self.spotlight.show()

func replenish_moves():
    self.reset_move()
    self.attacks = self.max_attacks

func can_attack(_unit):
    return true

func can_kill(unit):
    if not self.has_attacks() or not self.has_moves() or not self.can_attack(unit):
        return false

    return self.has_enough_power_to_kill(unit)

func can_retaliate(unit):
    if not self.has_moves() or not self.can_attack(unit):
        return false

    return true

func has_enough_power_to_kill(unit):
    return self.attack >= unit.hp + unit.armor

func has_attacks():
    return self.attacks > 0

func use_attack():
    self.attacks -= 1

func rotate_unit_to_direction(direction):
    if not self.unit_rotations.has(direction):
        return

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
        self.sfx_effect("move")
    else:
        self.execute_move_callback()

func stop_animations():
    self.animations.stop()

func execute_move_callback():
    if self.move_finished_object != null:
        if self.move_finished_args.size() > 0:
            self.move_finished_object.call_deferred(self.move_finished_method, self.move_finished_args)
        else:
            self.move_finished_object.call_deferred(self.move_finished_method)
        self.clear_move_callback()

func bind_move_callback(bound_object, bound_method, bound_args=[]):
    self.move_finished_object = bound_object
    self.move_finished_method = bound_method
    self.move_finished_args = bound_args

func clear_move_callback():
    self.bind_move_callback(null, "", [])

func reset_position_for_tile_view():
    var translation = $"mesh_anchor/mesh".get_translation()
    translation.y = 0

    $"mesh_anchor/mesh".set_translation(translation)
    self.remove_highlight()

func show_explosion():
    self.explosion.explode_a_bit()

func receive_damage(value):
    var final_damage = value - self.armor
    if final_damage < 0:
        final_damage = 0

    self.hp -= final_damage
    if self.hp < 0:
        self.hp = 0

func is_alive():
    return self.hp > 0

func get_attack():
    return self.attack

func remove_highlight():
    $"mesh_anchor/activity_light".hide()


func sfx_effect(name):
    var audio_player = self.get_node_or_null("audio/" + name)
    if audio_player != null:
        audio_player.play()

func give_sfx_effect(name):
    var audio_player = self.get_node_or_null("audio/" + name)
    if audio_player != null:
        $"audio".remove_child(audio_player)
        return audio_player
    return null
