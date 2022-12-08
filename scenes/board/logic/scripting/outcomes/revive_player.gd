extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var side

func _execute(_metadata):
    self.board.state.revive_player(self.side)

func _ingest_details(details):
    self.side = details['side']
