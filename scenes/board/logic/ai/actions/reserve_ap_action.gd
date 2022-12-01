extends "res://scenes/board/logic/ai/actions/abstract_action.gd"

var amount = 0

func _init(ap_amount):
    self.amount = ap_amount

func perform(board):
    board.ai.reserve_ap(self.amount)

func _to_string():
    return "Reserved AP for next turn: " + str(self.amount)
