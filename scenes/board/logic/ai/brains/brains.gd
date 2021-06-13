
var brains = {
    "hq" : preload("res://scenes/board/logic/ai/brains/hq_brain.gd").new(),
    "barracks" : preload("res://scenes/board/logic/ai/brains/barracks_brain.gd").new(),
    "factory" : preload("res://scenes/board/logic/ai/brains/factory_brain.gd").new(),
    "airfield" : preload("res://scenes/board/logic/ai/brains/airfield_brain.gd").new(),

    "infantry" : preload("res://scenes/board/logic/ai/brains/infantry_brain.gd").new(),
    "tank" : preload("res://scenes/board/logic/ai/brains/tank_brain.gd").new(),
    "heli" : preload("res://scenes/board/logic/ai/brains/heli_brain.gd").new(),
    "mobile_infantry" : preload("res://scenes/board/logic/ai/brains/infantry_brain.gd").new(),
    "rocket_artillery" : preload("res://scenes/board/logic/ai/brains/rocket_artillery_brain.gd").new(),
    "scout" : preload("res://scenes/board/logic/ai/brains/scout_brain.gd").new()
}

var assigned_brains = {
    "modern_airfield" : self.brains['airfield'],
    "modern_barracks" : self.brains['barracks'],
    "modern_factory" : self.brains['factory'],
    "modern_hq" : self.brains['hq'],
    "steampunk_airfield" : self.brains['airfield'],
    "steampunk_barracks" : self.brains['barracks'],
    "steampunk_factory" : self.brains['factory'],
    "steampunk_hq" : self.brains['hq'],

    "blue_infantry" : self.brains['infantry'],
    "blue_tank" : self.brains['tank'],
    "blue_heli" : self.brains['heli'],
    "blue_m_inf" : self.brains['mobile_infantry'],
    "blue_rocket" : self.brains['rocket_artillery'],
    "blue_scout" : self.brains['scout'],
    "red_infantry" : self.brains['infantry'],
    "red_tank" : self.brains['tank'],
    "red_heli" : self.brains['heli'],
    "red_m_inf" : self.brains['mobile_infantry'],
    "red_rocket" : self.brains['rocket_artillery'],
    "red_scout" : self.brains['scout'],
    "green_infantry" : self.brains['infantry'],
    "green_tank" : self.brains['tank'],
    "green_heli" : self.brains['heli'],
    "green_m_inf" : self.brains['mobile_infantry']
}

func get_brain_for_template(template_name):
    if self.assigned_brains.has(template_name):
        return self.assigned_brains[template_name]

    return null

