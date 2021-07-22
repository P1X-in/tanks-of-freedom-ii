extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var text
var portrait = null
var name
var side = "left"

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
    if details.has("portrait"):
        self.portrait = details['portrait']
    self.name = details['name']
    if details.has("side"):
        self.side = details['side']
