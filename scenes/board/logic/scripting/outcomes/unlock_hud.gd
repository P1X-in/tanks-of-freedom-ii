extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"


func _init():
    self.delay = 0.3

func _execute(_metadata):
    if not self.board.state.is_current_player_ai():
        self.board.ui.hide_cinematic_bars()
        self.board.map.camera.ai_operated = false
        self.board.map.show_tile_box()
