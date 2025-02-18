extends "res://scenes/board/logic/ai/actions/abstract_action.gd"

var unit
var path_length


func _init(unit_tile, target_tile, path_length_val):
	self.unit = unit_tile
	self.target = target_tile
	self.path_length = path_length_val


func perform(board):
	var unit_object = self.unit.unit.tile

	board.select_tile(self.unit.position)
	board.select_tile(self.target.position)
	board.unselect_tile()
	
	if unit_object and not unit_object.is_queued_for_deletion():
		await unit_object.move_finished


func _to_string():
	return str(self.unit.position) + " moves to " + str(self.target.position)
