extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var side
var suspended

func _execute(_metadata):
    var heroes = self.board.state.get_heroes_for_side(self.side)

    for hero in heroes:
        if self.suspended:
            hero.disable_abilities()
        else:
            hero.enable_abilities()

func _ingest_details(details):
    self.side = details['side']
    self.suspended = details['suspended']
