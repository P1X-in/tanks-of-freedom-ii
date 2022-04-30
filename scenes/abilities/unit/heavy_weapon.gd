extends "res://scenes/abilities/unit/active.gd"

const TWEEN_TIME = 0.1

export var damage = 8

func _execute(board, position):
    var tile = board.map.model.get_tile(position)
    tile.unit.tile.receive_damage(self.damage)
    self.source.sfx_effect("ab_attack")

    board.shoot_projectile(self.active_source_tile, tile, self.TWEEN_TIME)
    yield(self.get_tree().create_timer(self.TWEEN_TIME), "timeout")
    
    self.source.sfx_effect("ab_hit")
    if not tile.unit.tile.is_alive():
        var unit_id = tile.unit.tile.get_instance_id()
        var unit_type = tile.unit.tile.template_name
        var unit_side = tile.unit.tile.side
        board.events.emit_unit_destroyed(self.source, unit_id, unit_type, unit_side)
        board.destroy_unit_on_tile(tile)

    board.explode_a_tile(tile)

func is_tile_applicable(tile, _source_tile):
    return tile.has_enemy_unit(self.source.side)
