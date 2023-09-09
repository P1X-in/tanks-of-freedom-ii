extends "res://scenes/board/logic/ai/actions/abstract_action.gd"

var unit
var path_length

func _init(unit_tile, target_tile, path_length_val):
    self.unit = unit_tile
    self.target = target_tile
    self.path_length = path_length_val

func perform(board):
    board.select_tile(self.unit.position)
    board.select_tile(self.target.position)
    board.unselect_tile()
    await board.get_tree().create_timer(self.path_length * 0.1).timeout

func _to_string():
    return str(self.unit.position) + " moves to " + str(self.target.position)