extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var who
var pause

func _execute(_metadata):
    var tile = self.board.map.model.get_tile2(self.who[0], self.who[1])

    if self.pause:
        tile.unit.tile.ai_paused = true
        tile.unit.tile.remove_moves()
    else:
        tile.unit.tile.ai_paused = false
        tile.unit.tile.replenish_moves()

func _ingest_details(details):
    self.who = details['who']
    self.pause = details['pause']
