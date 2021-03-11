extends "res://scenes/board/logic/ai/brains/abstract_brain.gd"

const ENEMY_PROXIMITY = 4

var action_template = preload("res://scenes/board/logic/ai/actions/use_ability_action.gd")

func get_actions(entity_tile, _enemy_buildings, _enemy_units, ap):
    var spawn_points = self._get_spawn_points(entity_tile)

    if spawn_points.size() < 1:
        return []

    var building = entity_tile.building.tile
    var actions = []

    for ability in building.abilities:
        if ability.ap_cost <= ap:
            actions.append(self._create_ability_action(ability, self._select_random_spawn_point(spawn_points)))


    return actions

func _get_spawn_points(entity_tile):
    var spawn_points = []

    for neighbour in entity_tile.neighbours:
        if entity_tile.neighbours[neighbour].can_acommodate_unit():
            spawn_points.append(entity_tile.neighbours[neighbour])

    return spawn_points

func _create_ability_action(ability, target):
    return self.action_template.new(ability, target)

func _select_random_spawn_point(spawn_points):
    return spawn_points[randi() % spawn_points.size()]
