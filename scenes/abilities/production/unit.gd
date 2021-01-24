extends "res://scenes/abilities/ability.gd"

export var template_name = ""

func _init():
    self.TYPE = "production"

func execute(board, position):
    var new_unit = board.map.builder.place_unit(position, self.template_name, 0, board.state.get_current_side())
    board.use_current_player_ap(self.ap_cost)
    board.select_tile(position)

    new_unit.replenish_moves()
