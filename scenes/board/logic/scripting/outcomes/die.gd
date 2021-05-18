extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var who

func _execute(_metadata):
    var tile = self.board.map.model.get_tile(self.who)
    self.board.destroy_unit_on_tile(tile)

func _ingest_details(details):
    self.who = Vector2(details['who'][0], details['who'][1])
