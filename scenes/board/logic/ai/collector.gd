
var brains = preload("res://scenes/board/logic/ai/brains/brains.gd").new()

var board

func _init(board_object):
    self.board = board_object

func select_best_action():
    var actions = self._gather_all_actions()

    if actions is GDScriptFunctionState: # Still working.
        actions = yield(actions, "completed")

    if actions.size() > 0:
        actions = self._sort_actions(actions)
        return actions[0]

    return null

func _gather_all_actions():
    var side = self.board.state.get_current_side()
    var ap = self.board.state.get_current_ap() - self.board.ai._reserved_ap

    if ap <= 0:
        return []

    var buildings = self.board.map.model.get_player_buildings_tiles(side)
    var units = self.board.map.model.get_player_units_tiles(side)

    var enemy_buildings = self.board.map.model.get_enemy_buildings_tiles(side)
    var enemy_units = self.board.map.model.get_enemy_units_tiles(side)

    var buildings_actions = self._gather_building_actions(buildings, enemy_buildings, enemy_units, buildings, units, ap)
    if buildings_actions is GDScriptFunctionState: # Still working.
        buildings_actions = yield(buildings_actions, "completed")

    var units_actions = self._gather_unit_actions(units, enemy_buildings, enemy_units, buildings, units, ap)
    if units_actions is GDScriptFunctionState: # Still working.
        units_actions = yield(units_actions, "completed")

    return buildings_actions + units_actions

func _gather_building_actions(buildings, enemy_buildings, enemy_units, own_buildings, own_units, ap):
    var buildings_actions = []
    var brain

    for building_tile in buildings:
        brain = self.brains.get_brain_for_template(building_tile.building.tile.template_name)
        if brain == null:
            continue
        brain.board = self.board
        buildings_actions += brain.get_actions(building_tile, enemy_buildings, enemy_units, own_buildings, own_units, ap, self.board)
        yield(self.board.get_tree().create_timer(0.01), "timeout")

    return buildings_actions

func _gather_unit_actions(units, enemy_buildings, enemy_units, own_buildings, own_units, ap):
    var units_actions = []
    var brain

    for unit_tile in units:
        if unit_tile.unit.tile.ai_paused:
            continue
            
        brain = self.brains.get_brain_for_unit(unit_tile.unit.tile)
        if brain == null:
            continue
        units_actions += brain.get_actions(unit_tile, enemy_buildings, enemy_units, own_buildings, own_units, ap, self.board)
        yield(self.board.get_tree().create_timer(0.01), "timeout")

    return units_actions

func _sort_actions(actions):
    actions.sort_custom(self, "_customComparison")

    return actions


func _customComparison(a, b):
    return a.value > b.value

