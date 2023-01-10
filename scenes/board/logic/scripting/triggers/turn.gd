extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

var turn_no = null
var player_id = null

func _init():
    self.observed_event_type = ['turn_started']

func _observe(event):
    if self.turn_no != null and self.turn_no == event.turn_no:
        if self.player_id == null or self.player_id == event.player_id:
            self.execute_outcome(event)
    elif self.turn_no == null and self.player_id != null and self.player_id == event.player_id:
        self.execute_outcome(event)

func _get_outcome_metadata(event):
    return {
        'turn_no' : event.turn_no,
        'player_id' : event.player_id
    }

func ingest_details(details):
    if details.has('turn'):
        self.turn_no = details['turn']
    if details.has('player'):
        self.player_id = details['player']
    if details.has('player_side'):
        self.player_id = self.board.state.get_player_id_by_side(details['player_side'])

func get_save_data():
    var save_data = .get_save_data()
    save_data["turn_no"] = self.turn_no
    return save_data

func restore_from_state(state):
    .restore_from_state(state)
    self.turn_no = state["turn_no"]