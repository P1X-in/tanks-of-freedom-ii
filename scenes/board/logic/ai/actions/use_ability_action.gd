extends "res://scenes/board/logic/ai/actions/abstract_action.gd"

var ability
var target
var delay = 0

func _init(abilit_object, target_object):
    self.ability = abilit_object
    self.target = target_object

func perform(board):
    self.ability.execute(board, self.target.position)
    board.unselect_tile()
    if self.delay > 0:
        yield(board.get_tree().create_timer(self.delay), "timeout")
