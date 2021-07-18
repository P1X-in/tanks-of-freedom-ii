extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var amount
var side
var set_ap_value = false

func _execute(_metadata):
    var player_id = self.board.state.get_player_id_by_side(self.side)
    if self.set_ap_value:
        self.board.state.set_player_ap(player_id, self.amount)
    else:
        self.board.state.add_player_ap(player_id, self.amount)
    self.board.ui.update_resource_value(self.board.state.get_current_ap())  

func _ingest_details(details):
    self.amount = details['amount']
    self.side = details['side']

    if details.has("set"):
        self.set_ap_value = details["set"]
