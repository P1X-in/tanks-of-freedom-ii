extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var who
var which
var where
var cooldown = false

func _execute(_metadata):
    var unit_tile = self.board.map.model.get_tile(self.who)
    var ability = unit_tile.unit.tile.get_node(self.which)

    self.board.selected_tile = unit_tile
    ability.active_source_tile = unit_tile
    ability._execute(self.board, self.where)
    self.board.unselect_tile()

    if self.cooldown:
        ability.activate_cooldown(self.board)

func _ingest_details(details):
    self.who = Vector2(details['who'][0], details['who'][1])
    self.which = details['which']
    self.where = Vector2(details['where'][0], details['where'][1])
    if details.has('cooldown'):
        self.cooldown = details['cooldown']
