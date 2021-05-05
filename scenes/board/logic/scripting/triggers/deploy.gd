extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

var amount
var player_id = null
var player_side = null
var unit_type = null

func _init():
    self.observed_event_type = ['unit_spawned']

func _observe(event):
    var units
    var side

    if self.player_id != null:
        side = self.board.state.get_player_side_by_id(self.player_id)
    if self.player_side != null:
        side = self.player_side

    if event.unit.side == side:
        units = self.board.map.model.get_player_units(side)

        if self._count_units(units) >= self.amount:
            self.execute_outcome(event)

func _get_outcome_metadata(event):
    return {
        'amount' : self.amount,
        'player_id' : self.board.state.get_player_id_by_side(event.unit.side),
        'side' : event.unit.side,
        'unit' : event.unit,
        'source' : event.source,
        'type' : event.unit.template_name
    }

func ingest_details(details):
    self.amount = details['amount']
    if details.has('player'):
        self.player_id = details['player']
    if details.has('player_side'):
        self.player_side = details['player_side']
    if details.has('type'):
        self.unit_type = details['type']

func _count_units(units):
    if self.unit_type == null:
        return units.size()

    var counted = 0
    for unit in units:
        if unit.template_name == self.unit_type:
            counted += 1
    return counted
