extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var trigger_id
var vip

func _execute(_metadata):
    self.board.scripting.triggers[self.trigger_id].set_vip(self.vip[0], self.vip[1]) 

func _ingest_details(details):
    self.trigger_id = details['trigger_id']
    self.vip = details['vip']
