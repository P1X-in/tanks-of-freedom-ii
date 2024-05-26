
var brains = {
	"hq" : preload("res://scenes/board/logic/ai/brains/hq_brain.gd").new(),
	"barracks" : preload("res://scenes/board/logic/ai/brains/barracks_brain.gd").new(),
	"factory" : preload("res://scenes/board/logic/ai/brains/factory_brain.gd").new(),
	"airfield" : preload("res://scenes/board/logic/ai/brains/airfield_brain.gd").new(),

	"infantry" : preload("res://scenes/board/logic/ai/brains/infantry_brain.gd").new(),
	"tank" : preload("res://scenes/board/logic/ai/brains/tank_brain.gd").new(),
	"heli" : preload("res://scenes/board/logic/ai/brains/heli_brain.gd").new(),
	"mobile_infantry" : preload("res://scenes/board/logic/ai/brains/mobile_infantry_brain.gd").new(),
	"rocket_artillery" : preload("res://scenes/board/logic/ai/brains/rocket_artillery_brain.gd").new(),
	"scout" : preload("res://scenes/board/logic/ai/brains/scout_brain.gd").new(),

	"hero_admiral" : preload("res://scenes/board/logic/ai/brains/heroes/admiral_brain.gd").new(),
	"hero_captain" : preload("res://scenes/board/logic/ai/brains/heroes/captain_brain.gd").new(),
	"hero_commando" : preload("res://scenes/board/logic/ai/brains/heroes/commando_brain.gd").new(),
	"hero_general" : preload("res://scenes/board/logic/ai/brains/heroes/general_brain.gd").new(),
	"hero_gentleman" : preload("res://scenes/board/logic/ai/brains/heroes/gentleman_brain.gd").new(),
	"hero_noble" : preload("res://scenes/board/logic/ai/brains/heroes/noble_brain.gd").new(),
	"hero_prince" : preload("res://scenes/board/logic/ai/brains/heroes/prince_brain.gd").new(),
	"hero_warlord" : preload("res://scenes/board/logic/ai/brains/heroes/warlord_brain.gd").new(),

	"npc" : preload("res://scenes/board/logic/ai/brains/npc_brain.gd").new(),
	"hero" : preload("res://scenes/board/logic/ai/brains/hero_brain.gd").new()
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
	"futuristic_airfield" : self.brains['airfield'],
	"futuristic_barracks" : self.brains['barracks'],
	"futuristic_factory" : self.brains['factory'],
	"futuristic_hq" : self.brains['hq'],
	"feudal_airfield" : self.brains['airfield'],
	"feudal_barracks" : self.brains['barracks'],
	"feudal_factory" : self.brains['factory'],
	"feudal_hq" : self.brains['hq'],
}

func get_brain_for_template(template_name):
	if self.assigned_brains.has(template_name):
		return self.assigned_brains[template_name]

	return null

func get_brain_for_unit(unit):
	if unit.unit_class == "hero":
		if self.brains.has(unit.template_name):
			return self.brains[unit.template_name]

	if self.brains.has(unit.unit_class):
		return self.brains[unit.unit_class]

	return null
