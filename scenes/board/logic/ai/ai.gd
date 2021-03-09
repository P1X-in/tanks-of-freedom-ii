
var board

func _init(board_object):
    self.board = board_object

func run():

    yield(self.board.get_tree().create_timer(5), "timeout")

    self.board.end_turn()
