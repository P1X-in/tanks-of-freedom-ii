extends "res://scenes/board/logic/ai/brains/abstract_brain.gd"

const ENEMY_PROXIMITY = 4
const UNITS_HARD_LIMIT = 15
const UNITS_SOFT_LIMIT = 10

var action_template = preload("res://scenes/board/logic/ai/actions/use_ability_action.gd")

func get_actions(entity_tile, enemy_buildings, enemy_units, _own_buildings, own_units, ap):
    var spawn_points = self._get_spawn_points(entity_tile)

    if spawn_points.size() < 1:
        return []

    if own_units.size() >= self.UNITS_HARD_LIMIT:
        return []

    var building = entity_tile.building.tile
    var actions = []
    var action

    var bonus = self._calculate_proximity_value_bonus(entity_tile, enemy_units, enemy_buildings)
    var units_stats = self._gather_unit_stats(own_units)

    for ability in building.abilities:
        if ability.ap_cost <= ap:
            action = self._create_ability_action(ability, self._select_random_spawn_point(spawn_points))
            action.value = self._calculate_value(action, bonus, units_stats, ap)
            actions.append(action)

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
    spawn_points.shuffle()
    return spawn_points[0]

func _calculate_proximity_value_bonus(entity_tile, enemy_units, enemy_buildings):
    var bonus = 0
    var distance

    for enemy_unit_tile in enemy_units:
        distance = entity_tile.position.distance_squared_to(enemy_unit_tile.position)
        if distance <= 16:
            bonus += 10

    for enemy_building_tile in enemy_buildings:
        distance = entity_tile.position.distance_squared_to(enemy_building_tile.position)
        if distance <= 64:
            bonus += 1
        if distance <= 9:
            bonus += 10

    return bonus

func _calculate_value(action, bonus, units_stats, ap):
    var value = action.ability.ap_cost
    var template_name = self._map_template_name(action.ability.template_name)

    var unit_presence = 0.0

    if units_stats.has(template_name):
        unit_presence = float(units_stats[template_name]) / float(units_stats["total"])
    if unit_presence < 0.2:
        value += 30
    if unit_presence > 0.5:
        value -= 20

    if float(action.ability.ap_cost) / float(ap) >= 0.8:
        value -= 20

    if units_stats["total"] > self.UNITS_SOFT_LIMIT:
        value -= 10 * (units_stats["total"] - self.UNITS_SOFT_LIMIT)

    value += bonus

    return value

func _gather_unit_stats(units):
    var stats = {
        'total' : units.size()
    }
    var template_name

    for unit_tile in units:
        template_name = self._map_template_name(unit_tile.unit.tile.template_name)
        if stats.has(template_name):
            stats[template_name] += 1
        else:
            stats[template_name] = 1

    return stats

func _map_template_name(template_name):
    var map = {
        "blue_infantry" : "infantry",
        "blue_tank" : "tank",
        "blue_heli" : "heli",
        "blue_m_inf" : "m_inf",
        "blue_rocket" : "rocket",
        "blue_scout" : "scout",
        "red_infantry" : "infantry",
        "red_tank" : "tank",
        "red_heli" : "heli",
        "red_m_inf" : "m_inf",
        "red_rocket" : "rocket",
        "red_scout" : "scout",
        "green_infantry" : "infantry",
        "green_tank" : "tank",
        "green_heli" : "heli",
        "green_m_inf" : "m_inf",
        "green_rocket" : "rocket",
        "green_scout" : "scout",
        "yellow_infantry" : "infantry",
        "yellow_tank" : "tank",
        "yellow_heli" : "heli",
        "yellow_m_inf" : "m_inf",
        "yellow_rocket" : "rocket",
        "yellow_scout" : "scout"
    }

    return map[template_name]
