extends "res://scenes/tiles/units/unit.gd"

var passive_ability = null

var disable_active_abilities = false

func register_ability(ability):
    if ability.TYPE == "hero_passive":
        self.passive_ability = ability
    if ability.TYPE == "hero_active":
        self.active_abilities.append(ability)

    .register_ability(ability)


func has_active_ability():
    if self.disable_active_abilities:
        return false

    return self.active_abilities.size() > 0

func has_passive_ability():
    return self.passive_ability != null

func disable_abilities():
    self.disable_active_abilities = true

func enable_abilities():
    self.disable_active_abilities = false
