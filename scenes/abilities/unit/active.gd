extends "res://scenes/abilities/ability.gd"

export var named_icon = ""
export var marker_colour = "green"

func _init():
    self.TYPE = "active"

func execute(board, position):
    .execute(board, position)
    board.use_current_player_ap(self.ap_cost)
    self.source.use_move(1)

    if not board.state.is_current_player_ai():
        board.active_ability = null
        position = board.selected_tile.position
        board.unselect_tile()
        board.select_tile(position)

func is_tile_applicable(_tile, _source_tile):
    return true
