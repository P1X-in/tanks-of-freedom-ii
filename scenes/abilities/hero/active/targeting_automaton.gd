extends "res://scenes/abilities/hero/active/active.gd"

const TANK_TEMPLATES = [
    "blue_tank",
    "red_tank",
    "green_tank",
    "yellow_tank",
]

func _ready():
    self.label = "Targeting"
    self.label += "\n" + "Automaton"

func _execute(board, _position):
    var source_tile = board.selected_tile
    var unit

    for neighbour in source_tile.neighbours.values():
        if neighbour.has_friendly_unit(self.source.side):
            unit = neighbour.unit.tile
            if unit.template_name in self.TANK_TEMPLATES:
                unit.apply_modifier("attack_air", true)
            else:
                unit.apply_modifier("attack", 1)
            board.bless_a_tile(neighbour)

