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

func get_initial_level(template_name):
    if template_name in self.INFANTRY_TEMPLATES:
        return 1

    return 0
