extends "res://scenes/board/logic/ai/brains/abstract_unit_brain.gd"

func _gather_ability_actions(entity_tile, _ap, _board):
    var unit = entity_tile.unit.tile

    if not unit.has_moves():
        return []

    if not unit.has_active_ability():
        return []

    if unit.attacks > 0 and unit.move > 1:
        return []

    if self.pathfinder.enemy_units.size() < 1:
        return []

    var actions = []
    var action

    for ability in unit.active_abilities:
        if ability.is_visible() and not ability.is_on_cooldown():
            action = self._ability_action(ability, entity_tile)
            ability.active_source_tile = entity_tile
            action.delay = 0.5
            action.value = 50
            actions.append(action)

    return actions
