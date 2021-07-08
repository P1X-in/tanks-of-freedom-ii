extends "res://scenes/abilities/hero/passive/passive.gd"

func get_modified_cooldown(cd_value):
    if cd_value > 1:
        return cd_value - 1

    return cd_value
