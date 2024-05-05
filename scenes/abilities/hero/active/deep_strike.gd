extends "res://scenes/abilities/hero/active/active.gd"

@export var unit_template = "blue_infantry"

var deep_strike_executor_template = load("res://scenes/abilities/hero/active/deep_strike_executor.tscn")

func _execute(board, position):
    var executor = self.deep_strike_executor_template.instantiate()
    
    executor.set_up(board, position, self.source, self.unit_template)
    board.ability_markers.add_child(executor)
    executor.set_position(board.map.map_to_local(position))

func is_tile_applicable(tile, _source_tile):
    return tile.can_acommodate_unit()
