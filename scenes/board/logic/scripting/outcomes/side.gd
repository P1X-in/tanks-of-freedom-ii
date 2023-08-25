extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var who
var side

func _execute(_metadata):
    var tile = self.board.map.model.get_tile(self.who)

    if tile.unit.is_present():
        if tile.unit.tile.is_hero():
            self.board.state.clear_hero_for_side(tile.unit.tile.side, tile.unit.tile)
            self.board.state.add_hero_for_side(self.side, tile.unit.tile)

        self.board.map.builder.set_unit_side(self.who, self.side)
        tile.unit.tile.sfx_effect("spawn")  

func _ingest_details(details):
    self.who = Vector2(details['who'][0], details['who'][1])
    self.side = details['side']
