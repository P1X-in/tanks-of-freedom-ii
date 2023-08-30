extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var who
var whom
var damage = 0

func _execute(_metadata):
    var attacker_tile = self.board.map.model.get_tile(self.who)
    var defender_tile = self.board.map.model.get_tile(self.whom)
    var attacker = attacker_tile.unit.tile
    var defender = defender_tile.unit.tile

    attacker.rotate_unit_to_direction(attacker_tile.get_direction_to_neighbour(defender_tile))

    if self.damage > 0:
        defender.receive_direct_damage(self.damage)

    attacker.sfx_effect("attack")
    await self.board.get_tree().create_timer(self.board.RETALIATION_DELAY).timeout
    defender.show_explosion()
    defender.sfx_effect("damage")

func _ingest_details(details):
    self.who = Vector2(details['who'][0], details['who'][1])
    self.whom = Vector2(details['whom'][0], details['whom'][1])
    if details.has('damage'):
        self.damage = details['damage']
