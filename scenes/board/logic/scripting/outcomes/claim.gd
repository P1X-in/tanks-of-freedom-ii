extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var what
var side

func _execute(_metadata):
    var tile = self.board.map.model.get_tile(self.what)

    self.board.map.builder.set_building_side(self.what, self.side, self.board.state.get_player_team(self.side))
    self.board.smoke_a_tile(tile)
    tile.building.tile.sfx_effect("capture")  

func _ingest_details(details):
    self.what = Vector2(details['what'][0], details['what'][1])
    self.side = details['side']
