extends "res://scenes/abilities/hero/active/active.gd"

const HEAL = 5

func _execute(board, position):
	var source_tile = board.selected_tile

	if source_tile == null:
		source_tile = board.map.model.get_tile(position)

	for neighbour in source_tile.neighbours.values():
		if neighbour.has_friendly_unit(self.source.side):
			neighbour.unit.tile.heal(self.HEAL)
			board.heal_a_tile(neighbour)

