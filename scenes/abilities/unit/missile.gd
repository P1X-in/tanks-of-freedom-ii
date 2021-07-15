extends "res://scenes/abilities/unit/active.gd"

const TWEEN_TIME = 0.5

export var damage = 10
export var min_level = 0
export var max_level = 3

func _execute(board, position):
    var tile = board.map.model.get_tile(position)
    self.source.sfx_effect("attack")

    board.smoke_a_tile(self.active_source_tile)
    board.lob_projectile(self.active_source_tile, tile, self.TWEEN_TIME)
    yield(self.get_tree().create_timer(self.TWEEN_TIME), "timeout")
    
    tile.unit.tile.sfx_effect("damage")
    tile.unit.tile.receive_damage(self.damage)
    if not tile.unit.tile.is_alive():
        var unit_id = tile.unit.tile.get_instance_id()
        var unit_side = tile.unit.tile.side
        board.events.emit_unit_destroyed(self.source, unit_id, unit_side)
        board.destroy_unit_on_tile(tile)

    board.explode_a_tile(tile)
    self.source.activate_all_cooldowns(board)

func _is_visible(_board=null):
    if self.source == null:
        return false

    return self.source.level >= self.min_level and self.source.level <= self.max_level

func is_tile_applicable(tile, source_tile):
    return tile.has_enemy_unit(self.source.side) and not tile.is_neighbour(source_tile)
