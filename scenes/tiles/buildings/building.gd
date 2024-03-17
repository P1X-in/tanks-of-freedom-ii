extends "res://scenes/tiles/tile.gd"
class_name BaseBuilding

@onready var audio = $"/root/SimpleAudioLibrary"

@onready var animations = $"animations"

@export var side = "neutral"
var team = null

@export var require_crew = true

@export var ap_gain = 5

@export var capture_value = 70

@export var uses_metallic_material = false

var abilities = []

func get_dict():
	var new_dict = super.get_dict()
	new_dict["side"] = self.side
	new_dict["abilities"] = self._get_abilities_status()

	return new_dict

func set_side(new_side):
	self.side = new_side

func set_team(new_team):
	self.team = new_team

func set_side_materials(_base_material, _desaturated_material):
	self.set_side_material(_base_material)

func set_side_material(material):
	$"mesh".set_surface_override_material(0, material)

func register_ability(ability):
	self.abilities.append(ability)

func animate_coin():
	self.animations.play("ap_gain")

func sfx_effect(sfx_name):
	if not self.audio.sounds_enabled:
		return

	var audio_player = self.get_node_or_null("audio/" + sfx_name)
	if audio_player != null:
		audio_player.play()

func _get_abilities_status():
	var status = {}

	for ability in self.abilities:
		status["ability" + str(ability.index)] = ability.disabled

	return status

func restore_abilities_status(status):
	var key
	for ability in self.abilities:
		key = "ability" + str(ability.index)
		if status.has(key):
			ability.disabled = status[key]

func disable_dlc_abilities(editor_version):
	for ability in self.abilities:
		if ability.dlc_version > editor_version:
			ability.disabled = true
