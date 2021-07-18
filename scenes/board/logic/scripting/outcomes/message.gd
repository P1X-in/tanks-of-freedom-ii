extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var text
var portrait
var name
var side

func _execute(_metadata):
    var actor = {
        'portrait' : self.portrait,
        'portrait_tile' : self.board.map.templates.get_template(self.portrait),
        'name' : self.name,
        'side' : self.side
    }

    actor['portrait_tile'].tile_view_height_cam_modifier = -0.2

    self.board.ui.show_story_dialog(text, actor)

func _ingest_details(details):
    self.text = details['text']
    self.portrait = details['portrait']
    self.name = details['name']
    self.side = details['side']
