class_name Hero
extends SpawnUnit

func _is_visible(board=null):
	if self.source == null:
		return false

	if board == null:
		return false

	if board.state.has_side_a_hero(self.source.side):
		return false

	return true
