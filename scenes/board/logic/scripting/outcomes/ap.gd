extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var amount
var side

func _execute(_metadata):
    var player_id = self.board.state.get_player_id_by_side(self.side)
    self.board.state.add_player_ap(player_id, self.amount)
    self.board.ui.update_resource_value(self.board.state.get_current_ap())  

func _ingest_details(details):
    self.amount = details['amount']
    self.side = details['side']
