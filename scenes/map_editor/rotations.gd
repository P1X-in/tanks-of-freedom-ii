
var rotations = {}
var types = {}
var players = {}
var stored_state = {}

func build_rotations(templates, builder):
	self.rotations[builder.CLASS_GROUND] = self.build_from_array([
		templates.GROUND_GRASS,
		templates.GROUND_CONCRETE,
		templates.GROUND_RIVER1,
		templates.GROUND_RIVER2,
		templates.GROUND_ROAD1,
		templates.GROUND_ROAD2,
		templates.GROUND_ROAD3,
		templates.GROUND_ROAD4,
		templates.GROUND_DIRT_ROAD1,
		templates.GROUND_DIRT_ROAD2,
		templates.GROUND_DIRT_ROAD3,
		templates.GROUND_DIRT_ROAD4,
	])

	self.rotations[builder.CLASS_FRAME] = self.build_from_array([
		templates.FRAME_GRASS1,
		templates.FRAME_GRASS2,
		templates.FRAME_GRASS3,
		templates.FRAME_GRASS4,
		templates.FRAME_RIVER1,
		templates.FRAME_RIVER2,
		templates.FRAME_RIVER3,
		templates.FRAME_RIVER4,
		templates.FRAME_ROAD1,
		templates.FRAME_ROAD2,
		templates.FRAME_ROAD3,
		templates.FRAME_ROAD4,
		templates.FRAME_FENCE,
	])

	self.rotations[builder.CLASS_DECORATION] = self.build_from_array([
		templates.DECO_FLOWERS1,
		templates.DECO_FLOWERS2,
		templates.DECO_FLOWERS3,
		templates.DECO_FLOWERS4,
		templates.DECO_FLOWERS5,
		templates.DECO_FLOWERS6,
		templates.DECO_FLOWERS7,
		templates.DECO_LOG,
		templates.DECO_ROCKS1,
		templates.DECO_ROCKS2,
	])

	self.rotations[builder.CLASS_TERRAIN] = self.build_from_array([
		templates.CITY_BUILDING_BIG1,
		templates.CITY_BUILDING_BIG2,
		templates.CITY_BUILDING_BIG3,
		templates.CITY_BUILDING_BIG4,
		templates.CITY_BUILDING_SMALL1,
		templates.CITY_BUILDING_SMALL2,
		templates.CITY_BUILDING_SMALL3,
		templates.CITY_BUILDING_SMALL4,
		templates.CITY_BUILDING_SMALL5,
		templates.CITY_BUILDING_SMALL6,
		templates.DECO_FOUNTAIN,
		templates.DECO_STATUE,
		templates.CITY_BRIDGE,
		templates.NATURE_BIG_ROCKS1,
		templates.NATURE_BIG_ROCKS2,
		templates.NATURE_BIG_ROCKS3,
		templates.NATURE_TREES1,
		templates.NATURE_TREES2,
		templates.NATURE_TREES3,
		templates.NATURE_TREES4,
		templates.NATURE_TREES5,
		templates.NATURE_TREES6,
	])

	self.rotations[builder.CLASS_BUILDING] = self.build_from_array([
		templates.MODERN_HQ,
		templates.MODERN_AIRFIELD,
		templates.MODERN_BARRACKS,
		templates.MODERN_FACTORY,
		templates.MODERN_TOWER,

		templates.STEAMPUNK_HQ,
		templates.STEAMPUNK_AIRFIELD,
		templates.STEAMPUNK_BARRACKS,
		templates.STEAMPUNK_FACTORY,
		templates.STEAMPUNK_TOWER,

		templates.FUTURISTIC_HQ,
		templates.FUTURISTIC_AIRFIELD,
		templates.FUTURISTIC_BARRACKS,
		templates.FUTURISTIC_FACTORY,
		templates.FUTURISTIC_TOWER,
	])

	self.rotations[builder.CLASS_UNIT] = self.build_from_array([
		templates.UNIT_BLUE_INFANTRY,
		templates.UNIT_BLUE_TANK,
		templates.UNIT_BLUE_HELI,
		templates.UNIT_BLUE_MINF,
		templates.UNIT_BLUE_ROCKET,
		templates.UNIT_BLUE_SCOUT,

		templates.UNIT_RED_INFANTRY,
		templates.UNIT_RED_TANK,
		templates.UNIT_RED_HELI,
		templates.UNIT_RED_MINF,
		templates.UNIT_RED_ROCKET,
		templates.UNIT_RED_SCOUT,

		templates.UNIT_GREEN_INFANTRY,
		templates.UNIT_GREEN_TANK,
		templates.UNIT_GREEN_HELI,
		templates.UNIT_GREEN_MINF,
		templates.UNIT_GREEN_ROCKET,
		templates.UNIT_GREEN_SCOUT,
	])

	self.types = self.build_from_array([
		builder.CLASS_GROUND,
		builder.CLASS_FRAME,
		builder.CLASS_DECORATION,
		builder.CLASS_TERRAIN,
		builder.CLASS_BUILDING,
		builder.CLASS_UNIT,
	])

	self.players = self.build_from_array([
		templates.PLAYER_NEUTRAL,
		templates.PLAYER_BLUE,
		templates.PLAYER_RED,
		templates.PLAYER_GREEN,
		templates.PLAYER_YELLOW,
	])


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
