extends "res://scenes/abilities/hero/passive/passive.gd"

const FACTORY_TEMPLATES = [
    "blue_tank",
    "blue_rocket",
    "red_tank",
    "red_rocket",
    "green_tank",
    "green_rocket",
    "yellow_tank",
    "yellow_rocket",
]

func get_modified_cost(cost, template_name):
    if template_name in self.FACTORY_TEMPLATES:
        return cost - 10

    return cost
