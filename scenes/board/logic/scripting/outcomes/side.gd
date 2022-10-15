extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var who
var side

func _execute(_metadata):
    var tile = self.board.map.model.get_tile(self.who)

    self.board.map.builder.set_unit_side(self.who, self.side)
    tile.building.tile.sfx_effect("capture")  

func _ingest_details(details):
    self.who = Vector2(details['who'][0], details['who'][1])
    self.side = details['side']
