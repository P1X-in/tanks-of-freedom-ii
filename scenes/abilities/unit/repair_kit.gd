extends "res://scenes/abilities/unit/active.gd"

const REPAIR_UNITS = [
    "tank",
    "heli",
    "rocket_artillery",
    "scout",
]

@export var heal = 5

func _execute(board, position):
    var tile = board.map.model.get_tile(position)
    tile.unit.tile.sfx_effect("spawn")
    
    tile.unit.tile.heal(self.heal)
    board.heal_a_tile(tile)
    self.source.gain_exp()

    #self.source.activate_all_cooldowns(board)

func is_tile_applicable(tile, source_tile):
    return tile.has_friendly_unit(self.source.side) and tile != source_tile and (tile.unit.tile.unit_class in self.REPAIR_UNITS)

func _is_visible(_board=null):
    if self.source == null:
        return false

    return self.source.level >= 1

func get_cost():
    if self.source == null or self.source.level == 0:
        return super.get_cost()

    if self.source.level == 2:
        return 10
    return 5
