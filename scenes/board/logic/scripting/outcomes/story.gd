extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var steps = []

func _execute(metadata):
	self.board.map.camera.script_operated = true
	for step in steps:
		while self.board.ui.is_panel_open():
			await self.board.get_tree().create_timer(0.1).timeout
		step.execute(metadata)

		if step.delay > 0:
			await self.board.get_tree().create_timer(step.delay).timeout

	self.board.map.camera.script_operated = false

func add_step(step):
	self.steps.append(step)
