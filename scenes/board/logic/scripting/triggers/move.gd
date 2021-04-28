extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

var fields = []
var player_id = null
var player_side = null
var unit_tag = null

func _init():
    self.observed_event_type = 'unit_moved'

func _observe(event):
    if self._is_watched_tile(event.finish):
        if self.player_id != null:
            if self.player_id == self.board.state.get_player_id_by_side(event.unit.side):
                self.execute_outcome(event)
        elif self.player_side != null:
            if self.player_side == event.unit.side:
                self.execute_outcome(event)
        elif self.unit_tag != null:
            if event.unit.has_script_tag(self.unit_tag):
                self.execute_outcome(event)
        else:
            self.execute_outcome(event)

func _get_outcome_metadata(event):
    return {
        'field' : event.finish,
        'player_id' : self.board.state.get_player_id_by_side(event.unit.side),
        'side' : event.unit.side,
        'unit' : event.unit
    }

func ingest_details(details):
    self.fields = details['fields']
    if details.has('player'):
        self.player_id = details['player']
    if details.has('player_side'):
        self.player_side = details['player_side']
    if details.has('unit'):
        self.unit_tag = "move_" + str(details['unit'][0]) + "_" + str(details['unit'][1])
        self.board.map.model.get_tile2(details['unit'][0], details['unit'][1]).unit.tile.add_script_tag(self.unit_tag)
    if details.has('unit_tag'):
        self.unit_tag = details['unit_tag']

func _is_watched_tile(tile):
    for rectangle in self.fields:
        if tile.position.x >= rectangle["x1"] and tile.position.x <= rectangle["x2"] and tile.position.y >= rectangle["y1"] and tile.position.y <= rectangle["y2"]:
            return true
    return false
