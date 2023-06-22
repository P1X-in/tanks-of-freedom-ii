extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var who
var length

func _execute(_metadata):
    var tile = self.board.map.model.get_tile2(self.who[0], self.who[1])

    if not tile.unit.is_present():
        return

    tile.unit.tile.tether_point.x = self.who[0]
    tile.unit.tile.tether_point.y = self.who[1]
    tile.unit.tile.tether_length = self.length

func _ingest_details(details):
    self.who = details['who']
    self.length = details['length']
