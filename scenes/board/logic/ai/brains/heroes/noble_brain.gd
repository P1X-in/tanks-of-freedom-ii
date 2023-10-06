extends "res://scenes/board/logic/ai/brains/hero_brain.gd"

func _gather_ability_actions(entity_tile, ap, _board):
    var unit = entity_tile.unit.tile
    var ability = unit.active_abilities[0]

    if not unit.has_moves():
        return []
    if ability.ap_cost > ap or ability.is_on_cooldown():
        return []

    var path
    var actions = []
    var action
    var action_value
    var tiles_visited = []
    var target_tile
    var unit_range = unit.get_move()

    if unit_range > ap:
        unit_range = ap


    for friendly_unit_tile in self.pathfinder.own_units:
        target_tile = self.pathfinder.own_units[friendly_unit_tile]

        if target_tile.unit.tile == self:
            continue

        for neighbour in target_tile.neighbours.values():
            if tiles_visited.has(neighbour):
                continue
            tiles_visited.append(neighbour)
            if not neighbour.can_acommodate_unit(unit):
                continue
            path = self.pathfinder.get_path_to_tile(neighbour)
            if path.size() - 1 < unit_range:
                action_value = _calculate_support_value(unit, neighbour)
                if action_value >= 50:
                    action = self._move_action(entity_tile, path, unit_range - 1)
                    action.value = action_value
                    actions.append(action)
        
    action_value = _calculate_support_value(unit, entity_tile)
    if action_value >= 50:
        action = self._ability_action(ability, entity_tile)
        ability.active_source_tile = entity_tile
        action.delay = 0.5
        action.value = action_value
        actions.append(action)

    return actions

func _calculate_support_value(source, target_tile):
    var final_value = 0

    for tile in target_tile.neighbours.values():
        if tile.has_friendly_unit(source.side) and tile.neighbours_enemy_unit(source.side, source.team):
            if tile.unit.tile != self:
                final_value += tile.unit.tile.get_value()
                if tile.unit.tile.attacks > 0:
                    final_value += 20

    return final_value
