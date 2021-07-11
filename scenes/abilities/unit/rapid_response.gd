extends "res://scenes/abilities/unit/active.gd"

func _execute(board, position):
    var tile = board.map.model.get_tile(position)
    self.source.replenish_moves()
    board.bless_a_tile(tile)
