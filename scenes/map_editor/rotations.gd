
var rotations = {}
var types = {}
var players = {}
var stored_state = {}

func build_rotations(templates, builder):
	self.rotations[builder.CLASS_GROUND] = self.build_from_array(templates._ground_templates.keys())

	self.rotations[builder.CLASS_FRAME] = self.build_from_array(templates._frame_templates.keys())

	self.rotations[builder.CLASS_DECORATION] = self.build_from_array(templates._decoration_templates.keys() + templates._special_templates.keys())

	self.rotations[builder.CLASS_DAMAGE] = self.build_from_array(templates._damage_templates.keys())

	self.rotations[builder.SUB_CLASS_CONSTRUCTION] = self.build_from_array(templates._city_templates.keys() + templates._city_decoration_templates.keys() + templates._wall_templates.keys() + templates._railway_templates.keys())

	self.rotations[builder.CLASS_TERRAIN] = self.build_from_array(templates._nature_templates.keys())

	self.rotations[builder.CLASS_BUILDING] = self.build_from_array(templates._building_templates.keys())

	self.rotations[builder.CLASS_UNIT] = self.build_from_array(templates._unit_templates.keys())

	self.rotations[builder.CLASS_HERO] = self.build_from_array(templates._hero_templates.keys())

	self.types = self.build_from_array([
		builder.CLASS_GROUND,
		builder.CLASS_FRAME,
		builder.CLASS_DECORATION,
		builder.CLASS_DAMAGE,
		builder.CLASS_TERRAIN,
		builder.SUB_CLASS_CONSTRUCTION,
		builder.CLASS_BUILDING,
		builder.CLASS_UNIT,
		builder.CLASS_HERO,
	])

	self.players = self.build_from_array(templates.side_materials.keys())


func get_map(name, type):
	return self.rotations[type][name]

func get_type_map(type):
	return self.types[type]

func get_player_map(player):
	return self.players[player]

func get_first_tile(type):
	if self.stored_state.has(type):
		return self.stored_state[type]

	return self.rotations[type].keys()[0]

func build_from_array(names):
	var rotation_map = {}

	for i in range(names.size()):
		if i == 0:
			rotation_map[names[i]] = {
				"prev" : names[names.size()-1],
				"next" : names[i+1],
			}
		elif i + 1 == names.size():
			rotation_map[names[i]] = {
				"prev" : names[i-1],
				"next" : names[0],
			}
		else:
			rotation_map[names[i]] = {
				"prev" : names[i-1],
				"next" : names[i+1],
			}

	return rotation_map

func store_state(type, tile):
	self.stored_state[type] = tile
