extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var winner = null

func _execute(metadata):
    if self.winner == null:
        self.winner = metadata['new_side']

    self.board.end_game(self.winner)

func _ingest_details(details):
    if details.has('winner'):
        self.winner = details['winner']
