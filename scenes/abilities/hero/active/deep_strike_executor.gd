extends Spatial

var position
var source
var template_name
var board

func _ready():
    $"heli".sfx_effect("move")

func set_up(_board, _position, _source, _template_name):
    self.board = _board
    self.position = _position
    self.source = _source
    self.template_name = _template_name

    self.set_side_material()

func set_side_material():
    var drop_ship = $"heli"

    drop_ship.set_side(self.source.side)
    drop_ship.set_side_material(self.board.map.templates.get_side_material(self.source.side, self.board.map.templates.MATERIAL_METALLIC))

func _deploy_unit():
    var new_unit = self.board.map.builder.place_unit(self.position, self.template_name, 90, self.source.side)

    new_unit.remove_moves()
    self.board.abilities.apply_passive_modifiers(new_unit)
    new_unit.sfx_effect("spawn")

    self.board.events.emit_unit_spawned(self.source, new_unit)
