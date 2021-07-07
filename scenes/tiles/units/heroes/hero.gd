extends "res://scenes/tiles/units/unit.gd"

var passive_ability = null

func register_ability(ability):
    if ability.TYPE == "hero_passive":
        self.passive_ability = ability

    .register_ability(ability)

func has_passive_ability():
    return self.passive_ability != null
