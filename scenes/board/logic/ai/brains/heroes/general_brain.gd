extends "res://scenes/board/logic/ai/brains/hero_brain.gd"

func _gather_ability_actions(entity_tile, ap, board):
	var unit = entity_tile.unit.tile
	var ability = unit.active_abilities[0]

	if not unit.has_moves():
		return []
	if ability.ap_cost > ap or ability.is_on_cooldown():
		return []

	var actions = []
	var action
	var tiles_in_range = []


	tiles_in_range = board.ability_markers.get_all_tiles_in_ability_range(ability, entity_tile)

	for tile in tiles_in_range:
		if ability.is_tile_applicable(tile, entity_tile):
			action = self._ability_action(ability, tile)
			ability.active_source_tile = entity_tile
			action.delay = 0.5
			action.value = _calculate_drop_value(unit, tile)
			actions.append(action)

	return actions

func _calculate_drop_value(source, target_tile):
	var final_value = 40

	if target_tile.neighbours_enemy_unit(source.side, source.team):
		final_value -= 10
	if target_tile.neighbours_enemy_building(source.side, source.team):
		final_value += 100

	return final_value
