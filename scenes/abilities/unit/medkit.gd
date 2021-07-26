extends "res://scenes/abilities/unit/active.gd"

const MEDKIT_UNITS = [
    "infantry",
    "mobile_infantry",
    "hero",
    "npc",
]

export var heal = 5

func _execute(board, position):
    var tile = board.map.model.get_tile(position)
    tile.unit.tile.sfx_effect("spawn")
    
    tile.unit.tile.heal(self.heal)
    board.heal_a_tile(tile)

    #self.source.activate_all_cooldowns(board)

func is_tile_applicable(tile, source_tile):
    return tile.has_friendly_unit(self.source.side) and tile != source_tile and (tile.unit.tile.unit_class in self.MEDKIT_UNITS)
