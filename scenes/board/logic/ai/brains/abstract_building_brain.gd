extends "res://scenes/board/logic/ai/brains/abstract_brain.gd"

const ENEMY_PROXIMITY = 4
const UNITS_HARD_LIMIT = 5
const HARD_LIMIT_MULTIPLIER = 1.3
const UNITS_SOFT_LIMIT = 10

var action_template = preload("res://scenes/board/logic/ai/actions/use_ability_action.gd")
var reserve_template = preload("res://scenes/board/logic/ai/actions/reserve_ap_action.gd")

func get_actions(entity_tile, enemy_buildings, enemy_units, own_buildings, own_units, ap, board):
    var spawn_points = self._get_spawn_points(entity_tile)

    if spawn_points.size() < 1:
        return []

    var units_stats = self._gather_unit_stats(own_units)
    var final_units_hard_limit = self.UNITS_HARD_LIMIT + int(own_buildings.size() * self.HARD_LIMIT_MULTIPLIER)
    if units_stats["total"] >= final_units_hard_limit:
        return []

    var building = entity_tile.building.tile
    var actions = []
    var action
    var ability_cost

    var bonus = self._calculate_proximity_value_bonus(entity_tile, enemy_units, enemy_buildings)

    for ability in building.abilities:
        if not ability.is_visible(self.board):
            continue

        action = null
        ability_cost = board.abilities.get_modified_cost(ability.ap_cost, ability.template_name, building)
        if ability_cost <= ap:
            action = self._create_ability_action(ability, self._select_random_spawn_point(spawn_points))
            ability.active_source_tile = entity_tile
        elif ability_cost * 0.75 <= ap:
            action = self._create_reserve_ap_action(int(ability_cost/2))

        if action != null:
            action.value = self._calculate_value(ability, bonus, units_stats, ap)
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

func _create_reserve_ap_action(ap_amount):
    return self.reserve_template.new(ap_amount)

func _select_random_spawn_point(spawn_points):
    spawn_points.shuffle()
    return spawn_points[0]

func _calculate_proximity_value_bonus(entity_tile, enemy_units, enemy_buildings):
    var bonus = 0
    var distance

    for enemy_unit_tile in enemy_units:
        distance = entity_tile.position.distance_squared_to(enemy_unit_tile.position)
        if distance <= 16:
            bonus += 5
        if distance <= 64:
            bonus += 2
        if distance <= 100:
            bonus += 1

    for enemy_building_tile in enemy_buildings:
        distance = entity_tile.position.distance_squared_to(enemy_building_tile.position)
        if distance <= 64:
            bonus += 1
        if distance <= 9:
            bonus += 10

    return bonus

func _calculate_value(ability, bonus, units_stats, ap):
    var value = ability.ap_cost
    var template_name = self._map_template_name(ability.template_name)

    var unit_presence = 0.0

    if units_stats.has(template_name):
        unit_presence = float(units_stats[template_name]) / float(units_stats["total"])
    if unit_presence < 0.2:
        value += 30
    if unit_presence > 0.5:
        value -= 20

    if float(ability.ap_cost) / float(ap) >= 0.8:
        value -= 20

    if units_stats["total"] > self.UNITS_SOFT_LIMIT:
        value -= 10 * (units_stats["total"] - self.UNITS_SOFT_LIMIT)

    value += bonus

    return value

func _gather_unit_stats(units):
    var stats = {
        'total' : units.size()
    }
    var unit_class

    for unit_tile in units:
        if unit_tile.unit.tile.ai_paused:
            stats['total'] -= 1
            continue

        unit_class = unit_tile.unit.tile.unit_class
        if stats.has(unit_class):
            stats[unit_class] += 1
        else:
            stats[unit_class] = 1

    return stats

func _map_template_name(template_name):
    var map = {
        "blue_infantry" : "infantry",
        "blue_tank" : "tank",
        "blue_heli" : "heli",
        "blue_m_inf" : "mobile_infantry",
        "blue_rocket" : "rocket_artillery",
        "blue_scout" : "scout",
        "blue_truck" : "npc",
        "red_infantry" : "infantry",
        "red_tank" : "tank",
        "red_heli" : "heli",
        "red_m_inf" : "mobile_infantry",
        "red_rocket" : "rocket_artillery",
        "red_scout" : "scout",
        "red_truck" : "npc",
        "green_infantry" : "infantry",
        "green_tank" : "tank",
        "green_heli" : "heli",
        "green_m_inf" : "mobile_infantry",
        "green_rocket" : "rocket_artillery",
        "green_scout" : "scout",
        "green_truck" : "npc",
        "yellow_infantry" : "infantry",
        "yellow_tank" : "tank",
        "yellow_heli" : "heli",
        "yellow_m_inf" : "mobile_infantry",
        "yellow_rocket" : "rocket_artillery",
        "yellow_scout" : "scout",
        "yellow_truck" : "npc",
        "npc_president" : "npc",
        "npc_lord" : "npc",
        "npc_chancellor" : "npc",
        "npc_king" : "npc",
        "hero_general" : "hero",
        "hero_commando" : "hero",
        "hero_gentleman" : "hero",
        "hero_noble" : "hero",
        "hero_admiral" : "hero",
        "hero_captain" : "hero",
        "hero_prince" : "hero",
        "hero_warlord" : "hero"
    }

    return map[template_name]
