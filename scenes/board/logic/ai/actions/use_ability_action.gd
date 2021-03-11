extends "res://scenes/board/logic/ai/actions/abstract_action.gd"

var ability
var target

func _init(abilit_object, target_object):
    self.ability = abilit_object
    self.target = target_object

func perform(board):
     self.ability.execute(board, self.target.position)
