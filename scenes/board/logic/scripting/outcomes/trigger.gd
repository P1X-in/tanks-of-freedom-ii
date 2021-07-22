extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var name
var suspended
var turns = null

func _execute(_metadata):
    self.board.scripting.suspend_trigger(self.name, self.suspended)
    if self.turns != null:
        self.board.scripting.triggers[self.name].turn_no = self.board.state.turn + self.turns

func _ingest_details(details):
    self.name = details['name']
    self.suspended = details['suspended']
    if details.has("turns"):
        self.turns = details["turns"]
