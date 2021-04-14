extends Node

var TYPE="undefined"

export var index = 0
export var label = ""
export var ap_cost = 0
var source = null

func _ready():
    self.signal_to_parent()
    
func signal_to_parent():
    self.signal(self.get_parent())

func signal(receiver):
    receiver.register_ability(self)
    self.source = receiver

func execute(board, position):
    self._execute(board, position)
    board.events.emit_ability_used(self, position)

func _execute(_board, _position):
    return
    
