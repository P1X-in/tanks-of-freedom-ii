extends "res://scenes/board/logic/ai/brains/abstract_unit_brain.gd"

func _gather_ability_actions(entity_tile, ap, board):
    var unit = entity_tile.unit.tile

    if not unit.has_moves():
        return []

    var approach_target_tile
    var path
    var actions = []
    var action
    var tiles_in_range = []
    var targets_in_range = []
    var unit_range = unit.get_move()

    if unit_range > ap:
        unit_range = ap

    for enemy_unit_tile in self.pathfinder.enemy_units:
        approach_target_tile = self.pathfinder.enemy_units[enemy_unit_tile]

        path = self.pathfinder.get_path_to_tile(approach_target_tile)

        if path.size() - 1 > unit_range + 2:
            action = self._approach_action(entity_tile, path, unit_range - 1)
            if action != null:
                action.value = approach_target_tile.unit.tile.unit_value - 20
                actions.append(action)

    for ability in unit.active_abilities:
        if ability.is_visible() and ability.ap_cost <= ap and not ability.is_on_cooldown():
            targets_in_range = []

            tiles_in_range = board.ability_markers.get_all_tiles_in_ability_range(ability, entity_tile)

            for tile in tiles_in_range:
                if ability.is_tile_applicable(tile, entity_tile):
                    targets_in_range.append(tile)

            for target_tile in targets_in_range:
                action = self._ability_action(ability, target_tile)
                ability.active_source_tile = entity_tile
                action.value = target_tile.unit.tile.unit_value
                actions.append(action)

    return actions
