extends Spatial

const DAMAGE = 5

var position
var source
var board

func _ready():
    $"heli".sfx_effect("move")

func set_up(_board, _position, _source):
    self.board = _board
    self.position = _position
    self.source = _source

    self.set_side_material()

func set_side_material():
    var drop_ship = $"heli"

    drop_ship.set_side(self.source.side)
    drop_ship.set_side_material(self.board.map.templates.get_side_material(self.source.side, self.board.map.templates.MATERIAL_METALLIC))

func _drop_the_bombu_man():
    var tile = self.board.map.model.get_tile(self.position)

    self._bomb_tile(tile)

    for neighbour in tile.neighbours.values():
        self._bomb_tile(neighbour)

func _bomb_tile(tile):
    $"heli".sfx_effect("attack")
    
    if tile.unit.is_present():
        tile.unit.tile.receive_direct_damage(self.DAMAGE)
        if not tile.unit.tile.is_alive():
            self.board.destroy_unit_on_tile(tile)

    self.board.explode_a_tile(tile)
