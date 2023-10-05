extends "res://scenes/board/logic/ai/brains/abstract_brain.gd"

const EXPLORE_DISTANCE = 16

var pathfinder = preload("res://scenes/board/logic/ai/pathfinder.gd").new()

var actions_templates = {
	'attack' : preload("res://scenes/board/logic/ai/actions/attack_action.gd"),
	'move' : preload("res://scenes/board/logic/ai/actions/move_action.gd"),
	'capture' : preload("res://scenes/board/logic/ai/actions/capture_action.gd"),
	'ability' : preload("res://scenes/board/logic/ai/actions/use_ability_action.gd"),
}
var counter_death_penalty = 20

func get_actions(entity_tile, _enemy_buildings, _enemy_units, _own_buildings, _own_units, ap, _board):
	var actions = []

	self.pathfinder.explore(entity_tile, self.EXPLORE_DISTANCE)

	actions += self._gather_attack_actions(entity_tile, ap)
	actions += self._gather_ability_actions(entity_tile, ap, _board)
	if entity_tile.unit.tile.can_capture:
		actions += self._gather_capture_actions(entity_tile, ap)

	return actions


func _gather_attack_actions(entity_tile, ap):
	var unit = entity_tile.unit.tile

	if not unit.has_moves() or not unit.has_attacks():
		return []

	var actions = []
	var target_tile
	var action
	var path
	var interaction_tiles
	var unit_range = unit.get_move()

	if unit_range > ap:
		unit_range = ap

	for enemy_unit_tile in self.pathfinder.enemy_units:
		target_tile = self.pathfinder.enemy_units[enemy_unit_tile]
		if not unit.can_attack(target_tile.unit.tile):
			continue

		if target_tile.unit.tile.ai_paused:
			continue

		if entity_tile.is_neighbour(target_tile):
			action = self._attack_action(entity_tile, null, target_tile, [])
			action.value += unit_range
			actions.append(action)
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
					action = self._attack_action(entity_tile, interaction_tile, target_tile, path)
					if action != null:
						action.value -= path.size()
						actions.append(action)

	return actions

func _gather_capture_actions(entity_tile, ap):
	var unit = entity_tile.unit.tile

	if not unit.has_moves():
		return []

	var actions = []
	var target_tile
	var action
	var path
	var interaction_tiles
	var unit_range = unit.get_move()

	if unit_range > ap:
		unit_range = ap

	for enemy_building_tile in self.pathfinder.enemy_buildings:
		target_tile = self.pathfinder.enemy_buildings[enemy_building_tile]

		if entity_tile.is_neighbour(target_tile):
			action = self._capture_action(entity_tile, null, target_tile, [])
			action.value = target_tile.building.tile.capture_value - (unit.get_value() - 20)
			actions.append(action)
			continue

		path = self.pathfinder.get_path_to_tile(target_tile)

		if path.size() - 1 > unit_range:
			action = self._approach_action(entity_tile, path, unit_range - 1)
			if action != null:
				action.value = 10
				actions.append(action)
		else:
			interaction_tiles = self._get_interaction_tiles(target_tile, entity_tile)

			for interaction_tile in interaction_tiles:
				path = self.pathfinder.get_path_to_tile(interaction_tile)

				if path.size() - 1 > unit_range - 1:
					action = self._approach_action(entity_tile, path, unit_range - 1)
					if action != null:
						action.value = 10
						actions.append(action)
				else:
					action = self._capture_action(entity_tile, interaction_tile, target_tile, path)
					if action != null:
						action.value = target_tile.building.tile.capture_value - (unit.get_value() - 20)
						action.value -= path.size()
						actions.append(action)

	return actions

func _gather_ability_actions(_entity_tile, _ap, _board):
	return []

func _attack_action(entity_tile, interaction_tile, target_tile, path):
	if self._is_beyond_tether(entity_tile.unit.tile, interaction_tile):
		return null

	var action = self.actions_templates['attack'].new(entity_tile, interaction_tile, target_tile, path.size())

	var value = target_tile.unit.tile.get_value()

	if entity_tile.unit.tile.can_kill(target_tile.unit.tile):
		value += 100
	else:
		if target_tile.unit.tile.can_retaliate(entity_tile.unit.tile):
			value -= 10
		if target_tile.unit.tile.can_retaliate(entity_tile.unit.tile) and target_tile.unit.tile.has_enough_power_to_kill(entity_tile.unit.tile):
			value -= self.counter_death_penalty

	action.value = value

	return action

func _capture_action(entity_tile, interaction_tile, target_tile, path):
	if self._is_beyond_tether(entity_tile.unit.tile, interaction_tile):
		return null

	return self.actions_templates['capture'].new(entity_tile, interaction_tile, target_tile, path.size())

func _ability_action(ability, target):
	return self.actions_templates['ability'].new(ability, target)

func _approach_action(entity_tile, path, unit_range):
	if unit_range < 1:
		return null

	var target_tile = self.pathfinder.visited_tiles[path[path.size() - unit_range - 1]]

	if self._is_beyond_tether(entity_tile.unit.tile, target_tile):
		return null

	if target_tile.can_acommodate_unit(entity_tile.unit.tile):
		return self.actions_templates['move'].new(entity_tile, target_tile, unit_range)
	else:
		var nearby_path
		var nearby_tiles = self._get_interaction_tiles(target_tile, entity_tile)

		for nearby_tile in nearby_tiles:
			nearby_path = self.pathfinder.get_path_to_tile(nearby_tile)
			if nearby_path.size() - 1 > unit_range:
				continue
			if nearby_tile.can_acommodate_unit(entity_tile.unit.tile):
				return self.actions_templates['move'].new(entity_tile, nearby_tile, nearby_path.size())

	return null

func _move_action(entity_tile, path, unit_range):
	if unit_range < 1:
		return null

	var target_tile_index = path.size() - unit_range - 1
	if target_tile_index < 0:
		target_tile_index = 0
	var target_tile = self.pathfinder.visited_tiles[path[target_tile_index]]

	if self._is_beyond_tether(entity_tile.unit.tile, target_tile):
		return null

	if target_tile.can_acommodate_unit(entity_tile.unit.tile):
		return self.actions_templates['move'].new(entity_tile, target_tile, unit_range)

	return null

func _get_interaction_tiles(tile, source_tile):
	var tiles = []
	for neighbour in tile.neighbours:
		if not tile.neighbours[neighbour].can_acommodate_unit(source_tile.unit.tile):
			continue
		if not self.pathfinder.is_tile_reachable(tile.neighbours[neighbour]):
			continue

		tiles.append(tile.neighbours[neighbour])

	return tiles

func _is_beyond_tether(unit, target_tile):
	if unit.tether_length < 1 or target_tile == null:
		return false

	var anchor_distance = abs(unit.tether_point.x - target_tile.position.x) + abs(unit.tether_point.y - target_tile.position.y)

	if OS.is_debug_build():
		print(unit.tether_point, " ", target_tile.position, " ", anchor_distance, " ", unit.tether_length)

	return anchor_distance > unit.tether_length
