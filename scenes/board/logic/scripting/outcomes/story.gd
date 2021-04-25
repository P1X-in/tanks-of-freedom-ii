extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var steps = []

func _execute(metadata):
    for step in steps:
        while self.board.ui.is_panel_open():
            yield(self.board.get_tree().create_timer(0.1), "timeout")
        step.execute(metadata)

func add_step(step):
    self.steps.append(step)
