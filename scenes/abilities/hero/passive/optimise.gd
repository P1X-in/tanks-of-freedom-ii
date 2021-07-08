extends "res://scenes/abilities/hero/passive/passive.gd"

const TOWER_TEMPLATES = [
    "modern_tower",
    "steampunk_tower",
    "futuristic_tower",
    "feudal_tower",
]

func get_modified_ap_gain(value, template_name):
    if template_name in self.TOWER_TEMPLATES:
        return value + 5

    return value
