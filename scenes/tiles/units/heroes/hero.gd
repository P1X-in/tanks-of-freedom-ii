extends "res://scenes/tiles/units/unit.gd"

var passive_ability = null

func register_ability(ability):
    if ability.TYPE == "hero_passive":
        self.passive_ability = ability
    if ability.TYPE == "hero_active":
        self.active_abilities.append(ability)

    .register_ability(ability)


func has_active_ability():
    return self.active_abilities.size() > 0

func has_passive_ability():
    return self.passive_ability != null
