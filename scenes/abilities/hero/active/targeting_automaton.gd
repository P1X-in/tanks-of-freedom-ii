extends "res://scenes/abilities/hero/active/active.gd"


func _execute(board, position):
	var source_tile = board.selected_tile
	var unit

	if source_tile == null:
		source_tile = board.map.model.get_tile(position)

	for neighbour in source_tile.neighbours.values():
		if neighbour.has_friendly_unit(self.source.side):
			unit = neighbour.unit.tile
			if unit.unit_class in ["tank", "mobile_infantry"]:
				unit.apply_modifier("attack_air", true)
				board.bless_a_tile(neighbour)
			elif unit.unit_class != "rocket_artillery":
				unit.apply_modifier("attack", 1)
				board.bless_a_tile(neighbour)

