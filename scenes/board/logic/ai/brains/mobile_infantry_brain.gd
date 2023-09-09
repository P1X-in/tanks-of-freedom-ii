extends "res://scenes/board/logic/ai/brains/abstract_unit_brain.gd"


func _gather_ability_actions(entity_tile, ap, _board):
    var unit = entity_tile.unit.tile

    if not unit.has_moves():
        return []

    if not unit.has_active_ability():
        return []

    var actions = []
    var target_tile
    var action
    var path
    var interaction_tiles
    var unit_range = unit.get_move()

    if unit_range > ap:
        unit_range = ap

    for ability in unit.active_abilities:
        if ability.is_visible() and ability.ap_cost <= ap and not ability.is_on_cooldown():
            for friendly_unit_tile in self.pathfinder.own_units:
                target_tile = self.pathfinder.own_units[friendly_unit_tile]
                
                if target_tile.unit.tile.max_hp - target_tile.unit.tile.hp < 5:
                    continue
                if not ability.is_tile_applicable(target_tile, entity_tile):
                    continue

                if entity_tile.is_neighbour(target_tile):
                    action = self._ability_action(ability, target_tile)
                    action.delay = 0.5
                    ability.active_source_tile = entity_tile
                    action.value += target_tile.unit.tile.get_value()
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
                            action = self._approach_action(entity_tile, path, path.size() - 1)
                            if action != null:
                                action.value = target_tile.unit.tile.get_value() - path.size()
                                actions.append(action)

    return actions
