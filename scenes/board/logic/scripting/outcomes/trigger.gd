extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var name
var suspended

func _execute(_metadata):
    self.board.scripting.suspend_trigger(self.name, self.suspended)

func _ingest_details(details):
    self.name = details['name']
    self.suspended = details['suspended']
