extends Spatial

export var template_name = ""
export var unit_can_stand = false
export var unit_can_fly = false
export var is_invisible = false

export var main_tile_view_cam_modifier = 0
export var side_tile_view_cam_modifier = 0
export var tile_view_height_cam_modifier = 0.0

export var unit_vertical_offset = 0

export var next_damage_stage_template = ""
export var base_stage_template = ""

export var shadow_override = false

var scripting_tags = {}
var current_rotation = 0

func get_dict():
    var rotation = self.get_rotation_degrees()

    return {
        "tile" : self.template_name,
        "rotation" : rotation.y,
    }

func reset_position_for_tile_view():
    var translation = $"mesh".get_translation()
    translation.y = 0

    $"mesh".set_translation(translation)

func add_script_tag(tag):
    self.scripting_tags[tag] = true

func has_script_tag(tag):
    return self.scripting_tags.has(tag)

func is_damageable():
    return not self.next_damage_stage_template == ""

func is_restoreable():
    return not self.base_stage_template == ""

func hide_mesh():
    $"mesh".hide()
    
func disable_shadow():
    $"mesh".cast_shadow = 0
    var reflection = self.get_node_or_null("reflection")
    if reflection != null:
        reflection.cast_shadow = 0

    for child in self.get_children():
        if child is Spatial:
            for next_child in child.get_children():
                if next_child is MeshInstance:
                    next_child.cast_shadow = 0
                    return
