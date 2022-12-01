extends "res://scenes/abilities/production/heroes/hero.gd"

func _execute(board, position):
    ._execute(board, position)

    var units = board.map.model.get_player_units(board.state.get_current_side())
    for unit in units:
        board.abilities.apply_passive_modifiers(unit)
