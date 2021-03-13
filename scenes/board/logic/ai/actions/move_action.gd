extends "res://scenes/board/logic/ai/actions/abstract_action.gd"

var unit
var target

func _init(unit_tile, target_tile):
    self.unit = unit_tile
    self.target = target_tile

func perform(board):
     board.select_tile(self.unit.position)
     board.select_tile(self.target.position)
     board.unselect_tile()
     yield(board.get_tree().create_timer(1), "timeout")
