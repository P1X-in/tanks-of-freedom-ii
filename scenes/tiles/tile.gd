extends Spatial

export var template_name = ""
export var unit_can_stand = false

export var main_tile_view_cam_modifier = 0
export var side_tile_view_cam_modifier = 0

export var unit_vertical_offset = 0

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

    
