extends Node3D
class_name MapTile

@export var template_name: String = ""
@export var unit_can_stand: bool = false
@export var unit_can_fly: bool = false
@export var is_invisible: bool = false
@export var can_share_space: bool = false

@export var main_tile_view_cam_modifier: int = 0
@export var side_tile_view_cam_modifier: int = 0
@export var tile_view_height_cam_modifier: float = 0.0

@export var unit_vertical_offset: int = 0

@export var next_damage_stage_template: String = ""
@export var base_stage_template: String = ""

@export var shadow_override: bool = false

var scripting_tags: Dictionary = {}
var current_rotation: int = 0

func get_dict() -> Dictionary:
	var tile_rotation: Vector3 = self.get_rotation_degrees()

	return {
		"tile" : self.template_name,
		"rotation" : tile_rotation.y,
		"tags" : self.scripting_tags
	}

func reset_position_for_tile_view() -> void:
	var mesh_position: Vector3 = $"mesh".get_position()
	mesh_position.y = 0

	$"mesh".set_position(mesh_position)

func add_script_tag(tag: String) -> void:
	self.scripting_tags[tag] = true

func has_script_tag(tag: String) -> bool:
	return self.scripting_tags.has(tag)

func is_damageable() -> bool:
	return not self.next_damage_stage_template == ""

func is_restoreable() -> bool:
	return not self.base_stage_template == ""

func hide_mesh() -> void:
	$"mesh".hide()

func disable_shadow() -> void:
	self._set_shadow(GeometryInstance3D.SHADOW_CASTING_SETTING_OFF)


func enable_shadow() -> void:
	self._set_shadow(GeometryInstance3D.SHADOW_CASTING_SETTING_ON)

func _set_shadow(shadow_value: GeometryInstance3D.ShadowCastingSetting) -> void:
	$"mesh".cast_shadow = shadow_value
	var reflection: MeshInstance3D = self.get_node_or_null("reflection")
	if reflection != null:
		reflection.cast_shadow = shadow_value

	for child: Node in $"mesh".get_children():
		if child is MeshInstance3D:
			child.cast_shadow = shadow_value

	for child: Node in self.get_children():
		if child is Node3D:
			for next_child: Node in child.get_children():
				if next_child is MeshInstance3D:
					next_child.cast_shadow = shadow_value
					return
