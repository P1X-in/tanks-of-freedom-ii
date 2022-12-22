extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var winner = null
var side = null
var force_kill = false

func _execute(metadata):
    if side != null:
        self.board.state.eliminate_player(self.side)
        return

    var bunkers = self.board.map.model.get_player_bunkers(metadata['old_side'])

    if bunkers.size() > 0 and not self.force_kill:
        return

    self.board.state.eliminate_player(metadata['old_side'])

    if self.board.state.count_alive_players() == 1 or self.board.state.count_alive_teams() == 1:
        if self.winner == null:
            self.winner = metadata['new_side']

        self.board.end_game(self.winner)

func _ingest_details(details):
    if details.has('winner'):
        self.winner = details['winner']
    if details.has('side'):
        self.side = details['side']
    if details.has('force'):
        self.force_kill = details['force']
