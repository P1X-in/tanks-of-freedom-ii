extends "res://scenes/abilities/hero/active/active.gd"

var tiles_in_range = {}
var units_in_range = []

func _ready():
    self.label = "Hardened"
    self.label += "\n" + "Armour"

func _execute(board, _position):
    var source_tile = board.selected_tile

    self._get_units_in_range(source_tile, self.source.side)

    for unit_tile in self.units_in_range:
        unit_tile.unit.tile.apply_modifier("armor", 1)
        board.bless_a_tile(unit_tile)

func _get_units_in_range(tile, side):
    self.tiles_in_range.clear()
    self.units_in_range.clear()
    self.tiles_in_range[self._get_key(tile)] = tile

    self._expand_from_tile(tile, 2, side)

func _expand_from_tile(tile, depth, side):
    if depth < 1:
        return

    var key

    for neighbour in tile.neighbours.values():
        key = self._get_key(neighbour)

        if not self.tiles_in_range.has(key):
            self.tiles_in_range[key] = neighbour

            if neighbour.has_friendly_unit(side) and neighbour.unit.tile != self.source:
                self.units_in_range.append(neighbour)

            self._expand_from_tile(neighbour, depth - 1, side)

func _get_key(tile):
    return str(tile.position.x) + "_" + str(tile.position.y)
