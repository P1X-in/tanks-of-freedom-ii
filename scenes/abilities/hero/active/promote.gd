extends "res://scenes/abilities/hero/active/active.gd"

func _execute(board, position):
    var tile = board.map.model.get_tile(position)

    tile.unit.tile.level_up()
    board.bless_a_tile(tile)

func is_tile_applicable(tile):
    return tile.has_friendly_unit(self.source.side) and tile.unit.tile != self.source and not tile.unit.tile.is_max_level()
