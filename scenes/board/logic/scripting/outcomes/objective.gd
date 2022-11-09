extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var slot = null
var text = null
var clear = false

func _execute(_metadata):
    if self.clear:
        if self.slot != null:
            self.board.ui.objectives.clear_objective_slot(self.slot)
        else:
            self.board.ui.objectives.clear()
    else:
        self.board.ui.objectives.set_objective_slot(self.slot, self.text)

func _ingest_details(details):
    if details.has('slot'):
        self.slot = details['slot']
    if details.has('text'):
        self.text = details['text']
    if details.has('clear'):
        self.clear = details['clear']
