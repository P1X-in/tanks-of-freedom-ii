extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var name
var group
var action

func _execute(_metadata):
    if self.action == "add":
        self.board.scripting.add_to_group(self.group, self.name)
    elif self.action == "remove":
        self.board.scripting.remove_from_group(self.group, self.name)
        

func _ingest_details(details):
    self.name = details['name']
    self.group = details['group']
    self.action = details['action']
