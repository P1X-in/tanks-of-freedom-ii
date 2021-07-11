extends "res://scenes/abilities/hero/active/active.gd"

func _execute(board, position):
    var source_tile = board.selected_tile
    var destination_tile = board.map.model.get_tile(position)

    destination_tile.unit.set_tile(source_tile.unit.tile)
    source_tile.unit.release()

    board.reset_unit_position(destination_tile, destination_tile.unit.tile)
    board.smoke_a_tile(source_tile)
    board.smoke_a_tile(destination_tile)

    board.events.emit_unit_moved(destination_tile.unit.tile, source_tile, destination_tile)

func is_tile_applicable(tile, _source_tile):
    return tile.can_acommodate_unit()
