
var brains = {
    "hq" : preload("res://scenes/board/logic/ai/brains/hq_brain.gd").new(),
    "barracks" : preload("res://scenes/board/logic/ai/brains/barracks_brain.gd").new(),
    "factory" : preload("res://scenes/board/logic/ai/brains/factory_brain.gd").new(),
    "airfield" : preload("res://scenes/board/logic/ai/brains/airfield_brain.gd").new()
}

var assigned_brains = {
    "modern_airfield" : self.brains['airfield'],
    "modern_barracks" : self.brains['barracks'],
    "modern_factory" : self.brains['factory'],
    "modern_hq" : self.brains['hq'],
    "steampunk_airfield" : self.brains['airfield'],
    "steampunk_barracks" : self.brains['barracks'],
    "steampunk_factory" : self.brains['factory'],
    "steampunk_hq" : self.brains['hq']
}

func get_brain_for_template(template_name):
    if self.assigned_brains.has(template_name):
        return self.assigned_brains[template_name]

    return null
    