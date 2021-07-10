extends "res://scenes/abilities/unit/active.gd"

func _execute(board, position):
    var tile = board.map.model.get_tile(position)
    self.source.sfx_effect("attack")
    
    tile.unit.tile.receive_damage(8)
    if not tile.unit.tile.is_alive():
        board.destroy_unit_on_tile(tile)

    board.explode_a_tile(tile)

func is_tile_applicable(tile):
    return tile.has_enemy_unit(self.source.side)
