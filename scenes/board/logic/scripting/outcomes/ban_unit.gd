extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var ability_id
var where
var ban

func _execute(_metadata):
    var tile = self.board.map.model.get_tile2(self.where[0], self.where[1])

    for ability in tile.building.tile.abilities:
        if ability.index == self.ability_id:
            ability.disabled = self.ban

func _ingest_details(details):
    self.ability_id = details['ability_id']
    self.where = details['where']
    self.ban = details['ban']
