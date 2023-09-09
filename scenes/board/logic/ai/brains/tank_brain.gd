extends "res://scenes/board/logic/ai/brains/abstract_unit_brain.gd"

func _gather_ability_actions(entity_tile, ap, board):
	var unit = entity_tile.unit.tile

	if not unit.has_moves():
		return []

	if not unit.has_active_ability():
		return []

	var actions = []
	var action
	var tiles_in_range = []
	var targets_in_range = []

	var target_tile
	var path
	var interaction_tiles
	var unit_range = unit.get_move()

	for ability in unit.active_abilities:
		if ability.is_visible() and ability.ap_cost <= ap and not ability.is_on_cooldown():
			targets_in_range = []

			tiles_in_range = board.ability_markers.get_all_tiles_in_ability_range(ability, entity_tile)

			for tile in tiles_in_range:
				if ability.is_tile_applicable(tile, entity_tile):
					targets_in_range.append(tile)

			for target in targets_in_range:
				action = self._ability_action(ability, target)
				ability.active_source_tile = entity_tile
				action.delay = 0.5
				action.value = target.unit.tile.unit_value + 50
				actions.append(action)


			for enemy_unit_tile in self.pathfinder.enemy_units:
				target_tile = self.pathfinder.enemy_units[enemy_unit_tile]

				if targets_in_range.has(target_tile):
					continue

				if not unit.can_attack(target_tile.unit.tile):
					continue

				path = self.pathfinder.get_path_to_tile(target_tile)

				if path.size() - 1 > unit_range:
					action = self._approach_action(entity_tile, path, unit_range - 1)
					if action != null:
						action.value = target_tile.unit.tile.get_value() - 20
						actions.append(action)
				else:
					interaction_tiles = self._get_interaction_tiles(target_tile, entity_tile)

					for interaction_tile in interaction_tiles:
						path = self.pathfinder.get_path_to_tile(interaction_tile)

						if path.size() - 1 > unit_range - 1:
							action = self._approach_action(entity_tile, path, unit_range - 1)
							if action != null:
								action.value = target_tile.unit.tile.get_value() - 20
								actions.append(action)
						else:
							action = self._approach_action(entity_tile, path, path.size() - 1)
							if action != null:
								action.value = target_tile.unit.tile.get_value() - path.size()
								actions.append(action)

	return actions
