extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var where
var template_name = null
var side
var rotation = 0

func _execute(_metadata):
    var tile = self.board.map.model.get_tile(self.where)
    tile.unit.clear()

    var new_unit = self.board.map.builder.place_unit(self.where, self.template_name, self.rotation, self.side)
    new_unit.replenish_moves()
    new_unit.sfx_effect("spawn")  

func _ingest_details(details):
    self.where = Vector2(details['where'][0], details['where'][1])
    self.template_name = details['template']
    self.side = details['side']
    if details.has('rotation'):
        self.rotation = details['rotation']
