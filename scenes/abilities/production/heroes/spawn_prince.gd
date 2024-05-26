class_name Prince
extends SpawnHero

func _execute(board, position):
	super._execute(board, position)

	var units = board.map.model.get_player_units(board.state.get_current_side())
	for unit in units:
		board.abilities.apply_passive_modifiers(unit)
