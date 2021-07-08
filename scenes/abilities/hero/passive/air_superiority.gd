extends "res://scenes/abilities/hero/passive/passive.gd"

const AIR_TEMPLATES = [
    "blue_heli",
    "blue_scout",
    "red_heli",
    "red_scout",
    "green_heli",
    "green_scout",
    "yellow_heli",
    "yellow_scout",
]

func get_modified_cost(cost, template_name):
    if template_name in self.AIR_TEMPLATES:
        return cost - 10

    return cost
