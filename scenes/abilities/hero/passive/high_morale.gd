extends "res://scenes/abilities/hero/passive/passive.gd"

const INFANTRY_TEMPLATES = [
    "blue_infantry",
    "blue_m_inf",
    "red_infantry",
    "red_m_inf",
    "green_infantry",
    "green_m_inf",
    "yellow_infantry",
    "yellow_m_inf",
]

func get_passive_modifiers(template_name):
    if template_name in self.INFANTRY_TEMPLATES:
        return {
            "attack" : 1,
            "armor" : 1,
        }

    return {}
