extends "res://scenes/abilities/hero/active/active.gd"

var precision_strike_executor_template = preload("res://scenes/abilities/hero/active/precision_strike_executor.tscn")

func _ready():
    self.label = "Precision"
    self.label += "\n" + "Strike"

func _execute(board, position):
    var executor = self.precision_strike_executor_template.instance()
    
    executor.set_up(board, position, self.source)
    board.ability_markers.add_child(executor)
    executor.set_translation(board.map.map_to_world(position))

func is_tile_applicable(tile):
    if tile.unit.is_present():
        return tile.unit.tile != self.source
    return true
