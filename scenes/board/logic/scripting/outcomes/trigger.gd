extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var name = null
var group = null
var suspended
var turns = null

func _execute(_metadata):
    if self.group != null:
        self.board.scripting.suspend_group(self.group, self.suspended)
    elif self.name != null:
        self.board.scripting.suspend_trigger(self.name, self.suspended)
        
        if self.turns != null:
            self.board.scripting.triggers[self.name].turn_no = self.board.state.turn + self.turns

func _ingest_details(details):
    self.suspended = details['suspended']
    if details.has("name"):
        self.name = details["name"]
    if details.has("group"):
        self.group = details["group"]
    if details.has("turns"):
        self.turns = details["turns"]
