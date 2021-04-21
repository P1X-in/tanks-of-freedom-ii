extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var text
var portrait
var name
var side

func _execute(_metadata):
    var actor = {
        'portrait' : self.portrait,
        'name' : self.name,
        'side' : self.side
    }

    self.board.ui.show_story_dialog(text, actor)

func ingest_details(details):
    self.text = details['text']
    self.portrait = details['portrait']
    self.name = details['name']
    self.side = details['side']
