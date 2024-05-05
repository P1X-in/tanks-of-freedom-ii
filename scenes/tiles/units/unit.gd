extends MapTile
class_name BaseUnit

signal move_finished

const MAX_LEVEL: int = 3
const EXP_PER_LEVEL: int = 2

@onready var audio: AudioLibrary = $"/root/SimpleAudioLibrary"

@onready var animations: AnimationPlayer = $"animations"
@onready var spotlight: SpotLight3D = $"mesh_anchor/activity_light"
@onready var explosion: Explosion = $"explosion"
@onready var level_star: Node3D = $"voxel_star"

var enable_healthbar: bool = false
@onready var healthbar_sprite: Sprite3D = $"mesh_anchor/healthbar"
@onready var healthbar: TextureProgressBar = $"mesh_anchor/healthbar/SubViewport/bar"
@onready var healthbar_lv1: Node2D = $"mesh_anchor/healthbar/SubViewport/level1"
@onready var healthbar_lv2: Node2D = $"mesh_anchor/healthbar/SubViewport/level2"
@onready var healthbar_lv3: Node2D = $"mesh_anchor/healthbar/SubViewport/level3"

@export var unit_name: String = ""
@export var side: String = "neutral"
var team: int = 0
@export var material_type: String = "normal"

@export var max_hp: int = 10
var hp: int = 0
@export var max_move: int = 4
var move: int = 0
@export var attack: int = 7
@export var armor: int = 2
@export var can_capture: bool = false
@export var can_fly: bool = false
@export var max_attacks: int = 1
@export var uses_metallic_material: bool = false
@export var unit_value: int = 0
@export var unit_class: String = ""
var attacks: int = 1
var level: int = 0
var experience: int = 0
var kills: int = 0

# AI modifiers
var ai_paused: bool = false
var tether_point: Vector2 = Vector2(0, 0)
var tether_length: int = 0
# AI modifiers end

var modifiers: Dictionary = {}
var passive_ability: PassiveAbility = null
var active_abilities: Array = []

var unit_rotations: Dictionary = {
	"s" : 0,
	"n" : 180,
	"e" : 90,
	"w" : 270,
}
var unit_translations: Dictionary = {
	"n" : Vector3(0, 0, -8),
	"s" : Vector3(0, 0, 8),
	"e" : Vector3(8, 0, 0),
	"w" : Vector3(-8, 0, 0),
}
var current_path: Array = []
var current_path_index: int = 0


var base_material: Material
var desaturated_material: Material

func _ready() -> void:
	self.animations.animation_finished.connect(_on_animation_finished)
	$"mesh_anchor/healthbar".texture = $"mesh_anchor/healthbar/SubViewport".get_texture()

func reset() -> void:
	var stats: Dictionary = self.get_stats_with_modifiers()

	self.hp = stats["max_hp"]
	self.move = stats["max_move"]
	self.attacks = stats["max_attacks"]
	self._update_healthbar()
	self._update_level()

func get_dict() -> Dictionary:
	var new_dict: Dictionary = super.get_dict()
	new_dict["side"] = self.side
	new_dict["modifiers"] = self.modifiers
	new_dict["ai_paused"] = self.ai_paused
	new_dict["stats"] = self.get_stats_with_modifiers()
	new_dict["abilities"] = self._get_abilities_status()
	new_dict["team"] = self.team

	return new_dict

func set_side(new_side: String) -> void:
	self.side = new_side

func set_side_materials(_base_material: Material, _desaturated_material: Material) -> void:
	self.base_material = _base_material
	self.desaturated_material = _desaturated_material
	self.set_side_material(self.base_material)

func set_side_material(material: Material) -> void:
	if material == null:
		return

	$"mesh_anchor/mesh".set_surface_override_material(0, material)

	var additional_mesh: MeshInstance3D

	additional_mesh = self.get_node_or_null("mesh_anchor/mesh2")
	if additional_mesh != null:
		additional_mesh.set_surface_override_material(0, material)

	additional_mesh = self.get_node_or_null("mesh_anchor/mesh3")
	if additional_mesh != null:
		additional_mesh.set_surface_override_material(0, material)


func get_stats() -> Dictionary:
	return {
		"hp" : self.hp,
		"move" : self.move,
		"attack" : self.attack,
		"armor" : self.armor,
		"max_move" : self.max_move,
		"max_hp" : self.max_hp,
		"attacks" : self.attacks,
		"max_attacks" : self.max_attacks,
		"level" : self.level,
		"experience" : self.experience,
		"kills" : self.kills,
	}

func get_stats_with_modifiers() -> Dictionary:
	var stats: Dictionary = self.get_stats()

	for stat_key: String in stats:
		if self.modifiers.has(stat_key):
			stats[stat_key] += self.modifiers[stat_key]

	if self.level > 1:
		stats["armor"] += 1
	if self.level > 2:
		stats["max_move"] += 1

	return stats

func get_move() -> int:
	var stats: Dictionary = self.get_stats_with_modifiers()
	return stats["move"]

func has_moves() -> bool:
	return self.move > 0

func use_move(value: int) -> void:
	self.move -= value
	if self.move < 1:
		self.remove_highlight()

func use_all_moves() -> void:
	self.use_move(self.move)

func reset_move() -> void:
	var stats: Dictionary = self.get_stats_with_modifiers()
	self.move = stats["max_move"]
	self.restore_highlight()

func replenish_moves() -> void:
	self.reset_move()
	var stats: Dictionary = self.get_stats_with_modifiers()
	self.attacks = stats["max_attacks"]

func remove_moves() -> void:
	self.attacks = 0
	self.use_all_moves()

func can_attack(_unit: BaseUnit) -> bool:
	return true

func can_kill(unit: BaseUnit) -> bool:
	if not self.has_attacks() or not self.has_moves() or not self.can_attack(unit):
		return false

	return self.has_enough_power_to_kill(unit)

func can_retaliate(unit: BaseUnit) -> bool:
	if not self.has_moves() or not self.can_attack(unit):
		return false

	return true

func has_enough_power_to_kill(unit: BaseUnit) -> bool:
	return self.get_attack() >= unit.hp + unit.get_armor()

func has_attacks() -> bool:
	return self.attacks > 0

func use_attack() -> void:
	self.attacks -= 1

func rotate_unit_to_direction(direction: String) -> void:
	if not self.unit_rotations.has(direction):
		return

	var unit_rotation: int = self.unit_rotations[direction]
	self.set_rotation(Vector3(0, deg_to_rad(unit_rotation), 0))
	self.current_rotation = unit_rotation

func animate_path(path: Array) -> void:
	self.current_path = path
	self.current_path_index = 0
	self._animate_initial_path_segment()

func _animate_initial_path_segment() -> void:
	var direction: String = self.current_path[self.current_path_index]
	self.move_in_direction(direction)

func _animate_next_path_segment() -> void:
	if self.current_path.size() == 0:
		return

	var direction: String = self.current_path[self.current_path_index]
	_reset_anchor_position()
	self.set_position(self.get_position() + self.unit_translations[direction])
	self.current_path_index += 1
	direction = self.current_path[self.current_path_index]
	self.move_in_direction(direction)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "move":
		_animate_next_path_segment()

func move_in_direction(direction: String) -> void:
	self.rotate_unit_to_direction(direction)
	if self.current_path_index < self.current_path.size() - 1:
		self.animations.play("move")
		self.sfx_effect("move")
	else:
		self.move_finished.emit()

func stop_animations() -> void:
	self.current_path = []
	self.current_path_index = 0
	self.animations.stop()
	_reset_anchor_position()
	self.level_star.hide()
	self.move_finished.emit()

func _reset_anchor_position() -> void:
	$"mesh_anchor".set_position(Vector3(0, 0, 0))

func reset_position_for_tile_view() -> void:
	var mesh_position: Vector3 = $"mesh_anchor/mesh".get_position()
	mesh_position.y = 0

	$"mesh_anchor/mesh".set_position(mesh_position)
	self.remove_highlight()

func show_explosion() -> void:
	self.explosion.explode_a_bit()

func receive_damage(value: int) -> void:
	if self.ai_paused:
		return

	var final_damage: int = value - self.get_armor()
	if final_damage < 0:
		final_damage = 0

	self.receive_direct_damage(final_damage)

func receive_direct_damage(value: int) -> void:
	if self.ai_paused:
		return

	self.hp -= value
	if self.hp < 0:
		self.hp = 0
	self._update_healthbar()

func is_alive() -> bool:
	return self.hp > 0

func get_attack() -> int:
	var stats: Dictionary = self.get_stats_with_modifiers()
	return stats["attack"]

func get_armor() -> int:
	var stats: Dictionary = self.get_stats_with_modifiers()
	return stats["armor"]

func remove_highlight() -> void:
	self.set_side_material(self.desaturated_material)
	#$"mesh_anchor/activity_light".hide()

func restore_highlight() -> void:
	if self.ai_paused:
		return
	self.set_side_material(self.base_material)
	#self.spotlight.show()

func sfx_effect(sfx_name: String) -> void:
	if not SimpleAudioLibrary.sounds_enabled:
		return

	var audio_player: AudioStreamPlayer = self.get_node_or_null("audio/" + sfx_name)
	if audio_player != null:
		audio_player.play()

func give_sfx_effect(sfx_name: String) -> AudioStreamPlayer:
	if not SimpleAudioLibrary.sounds_enabled:
		return null

	var audio_player: AudioStreamPlayer = self.get_node_or_null("audio/" + sfx_name)
	if audio_player != null:
		$"audio".remove_child(audio_player)
		return audio_player
	return null

func register_ability(ability: Ability) -> void:
	if ability.TYPE == "active":
		self.active_abilities.append(ability)

func has_active_ability()-> bool:
	return self.active_abilities.size() > 0 and self.level > 0

func ability_cd_tick_down() -> void:
	for ability: Ability in self.active_abilities:
		ability.cd_tick_down()

func reset_cooldown() -> void:
	for ability: Ability in self.active_abilities:
		ability.reset_cooldown()

func activate_all_cooldowns(board: GameBoard) -> void:
	for ability: Ability in self.active_abilities:
		ability.activate_cooldown(board)

func apply_modifier(modifier_name: String, value: int) -> void:
	self.modifiers[modifier_name] = value

func clear_modifiers() -> void:
	self.modifiers.clear()

func gain_exp() -> void:
	self.kills += 1
	if not self.is_max_level():
		self.experience += 1

		if self.experience == self.EXP_PER_LEVEL:
			self.experience = 0
			self.level_up()

func level_up() -> void:
	if not self.is_max_level():
		self.level += 1
		self.animations.play("level_up")
		self.sfx_effect("level_up")
		self._update_level()

func is_max_level() -> bool:
	return self.level >= self.MAX_LEVEL

func heal(value: int) -> void:
	var stats: Dictionary = self.get_stats_with_modifiers()
	self.hp += value
	if self.hp > stats["max_hp"]:
		self.hp = stats["max_hp"]
	self._update_healthbar()

func get_value() -> int:
	return self.unit_value + self.level * 10


func disable_shadow() -> void:
	super.disable_shadow()

	$"mesh_anchor/mesh".cast_shadow = 0

	var additional_mesh: MeshInstance3D

	additional_mesh = self.get_node_or_null("mesh_anchor/mesh2")
	if additional_mesh != null:
		additional_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	additional_mesh = self.get_node_or_null("mesh_anchor/mesh3")
	if additional_mesh != null:
		additional_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

func _get_abilities_status() -> Dictionary:
	var status: Dictionary = {}

	for ability: Ability in self.active_abilities:
		status["ability" + str(ability.index)] = [ability.disabled, ability.cd_turns_left]

	return status

func restore_from_state(state: Dictionary) -> void:
	self.scripting_tags = state["tags"]
	self.hp = state["stats"]["hp"]
	self.move = state["stats"]["move"]
	self.attacks = state["stats"]["attacks"]
	self.level = int(state["stats"]["level"])
	self.experience = int(state["stats"]["experience"])
	self.kills = int(state["stats"]["kills"])
	self.team = state["team"]
	self.modifiers = state["modifiers"]

	self._update_healthbar()
	self._update_level()

	if self.move < 1:
		self.remove_highlight()

	for ability: Ability in self.active_abilities:
		if state["abilities"].has("ability" + str(ability.index)):
			ability.disabled = state["abilities"]["ability" + str(ability.index)][0]
			ability.cd_turns_left = state["abilities"]["ability" + str(ability.index)][1]

func disable_dlc_abilities(editor_version: int) -> void:
	for ability: Ability in self.active_abilities:
		if ability.dlc_version > editor_version:
			ability.disabled = true

func is_hero() -> bool:
	return false

func _update_healthbar() -> void:
	self.healthbar.value = self.hp

func _update_level() -> void:
	self.healthbar_lv1.hide()
	self.healthbar_lv2.hide()
	self.healthbar_lv3.hide()
	if self.level == 1:
		self.healthbar_lv1.show()
	if self.level == 2:
		self.healthbar_lv2.show()
	if self.level == 3:
		self.healthbar_lv3.show()

func enable_health() -> void:
	self.enable_healthbar = true
	self.show_health()
func show_health() -> void:
	if not self.enable_healthbar:
		return
	self.healthbar_sprite.show()
func hide_health() -> void:
	self.healthbar_sprite.hide()
