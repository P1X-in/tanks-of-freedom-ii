extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

var amount = 0
var player_id = null
var player_side = null

func _init():
    self.observed_event_type = ['turn_started']

func _observe(event):
    if self.player_side != null:
        self.player_id = self.board.state.get_player_id_by_side(self.player_side)

    if self.player_id == event.player_id and self.amount <= self.board.state.get_player_ap(self.player_id):
        self.execute_outcome(event)

func _get_outcome_metadata(event):
    return {
        'turn_no' : event.turn_no,
        'player_id' : event.player_id
    }

func ingest_details(details):
    if details.has('amount'):
        self.amount = details['amount']
    if details.has('player'):
        self.player_id = details['player']
    if details.has('player_side'):
        self.player_side = details['player_side']
