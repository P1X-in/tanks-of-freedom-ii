
var winner = null
var board

func execute(metadata={}):
    var bunkers = self.board.map.model.get_player_bunkers(metadata['old_side'])

    if bunkers.size() > 0:
        return

    self.board.state.eliminate_player(metadata['old_side'])

    if self.board.state.count_alive_players() == 1:
        if self.winner == null:
            self.winner = metadata['new_side']

        self.board.end_game(self.winner)
