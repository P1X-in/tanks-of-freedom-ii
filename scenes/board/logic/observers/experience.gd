extends "res://scenes/board/logic/observers/observer.gd"

func _init(_board).(_board):
    self.observed_event_type = ['unit_destroyed']

func _observe(event):
    event.attacker.gain_exp()
