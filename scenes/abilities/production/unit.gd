extends "res://scenes/abilities/ability.gd"

export var template_name = ""

func _init():
    self.TYPE = "production"

func execute(board, position):
    board.map.builder.place_unit(position, self.template_name, 0, board.state.get_current_side())
    board.state.use_current_player_ap(self.ap_cost)
    board.select_tile(position)
