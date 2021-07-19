
var winner = null
var force_kill = false
var board

func execute(metadata={}):
    var bunkers = self.board.map.model.get_player_bunkers(metadata['old_side'])

    if bunkers.size() > 0 and not self.force_kill:
        return

    self.board.state.eliminate_player(metadata['old_side'])

    if self.board.state.count_alive_players() == 1:
        if self.winner == null:
            self.winner = metadata['new_side']

        self.board.end_game(self.winner)

func _ingest_details(details):
    if details.has('winner'):
        self.winner = details['winner']
    if details.has('force'):
        self.force_kill = details['force']
