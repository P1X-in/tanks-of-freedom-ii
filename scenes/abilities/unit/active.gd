extends "res://scenes/abilities/hero/hero.gd"

export var named_icon = ""
export var ability_range = 0
export var marker_colour = "green"

func _init():
    self.TYPE = "active"

func execute(board, position):
    .execute(board, position)
    board.use_current_player_ap(self.ap_cost)
    self.source.use_move(1)

func is_tile_applicable(_tile):
    return true
