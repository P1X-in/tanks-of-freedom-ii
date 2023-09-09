extends "res://scenes/board/logic/observers/observer.gd"

func _init(_board):
	super(_board)
	self.observed_event_type = ['unit_spawned']

func _observe(event):
	if event.unit.unit_class != "hero":
		return

	self.board.state.auto_set_hero(event.unit)
