
var winner = null
var board

func execute(metadata={}):
    if self.winner == null:
        self.winner = metadata['new_side']

    self.board.end_game(self.winner)
