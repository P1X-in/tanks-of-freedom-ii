
const CLASS_GROUND = "ground"
const CLASS_FRAME = "frame"
const CLASS_DECORATION = "decoration"
const CLASS_TERRAIN = "terrain"
const CLASS_BUILDING = "building"
const CLASS_UNIT = "unit"

var map

func _init(map):
	self.map = map


func place_ground(position, name, rotation):
	var tile = self.map.model.get_tile(position)
	self.place_element(position, name, rotation, 0, self.map.tiles_ground_anchor, tile.ground)

func place_frame(position, name, rotation):
	var tile = self.map.model.get_tile(position)

	if not tile.ground.is_present():
		return

	self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_frames_anchor, tile.frame)

func place_decoration(position, name, rotation):
	var tile = self.map.model.get_tile(position)

	if not tile.ground.is_present():
		return
	if tile.decoration.is_present():
		tile.decoration.clear()
	if tile.terrain.is_present():
		tile.terrain.clear()
	if tile.building.is_present():
		tile.building.clear()

	self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_terrain_anchor, tile.decoration)

func place_terrain(position, name, rotation):
	var tile = self.map.model.get_tile(position)

	if not tile.ground.is_present():
		return
	if tile.decoration.is_present():
		tile.decoration.clear()
	if tile.terrain.is_present():
		tile.terrain.clear()
	if tile.building.is_present():
		tile.building.clear()

	self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_terrain_anchor, tile.terrain)

func place_building(position, name, rotation):
	var tile = self.map.model.get_tile(position)

	if not tile.ground.is_present():
		return
	if tile.decoration.is_present():
		tile.decoration.clear()
	if tile.terrain.is_present():
		tile.terrain.clear()
	if tile.building.is_present():
		tile.building.clear()

	self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_buildings_anchor, tile.building)

func place_unit(position, name, rotation):
	return

func place_element(position, name, rotation, vertical_offset, anchor, tile_fragment):
	var new_tile = self.map.templates.get_template(name)
	var world_position = self.map.map_to_world(position)

	anchor.add_child(new_tile)
	world_position.y = vertical_offset
	new_tile.set_translation(world_position)
	new_tile.set_rotation(Vector3(0, deg2rad(rotation), 0))

	tile_fragment.set_tile(new_tile)

func clear_tile_layer(position):
	var tile = self.map.model.get_tile(position)

	if tile.unit.is_present():
		tile.unit.clear()
	elif tile.building.is_present():
		tile.building.clear()
	elif tile.terrain.is_present():
		tile.terrain.clear()
	elif tile.decoration.is_present():
		tile.decoration.clear()
	elif tile.frame.is_present():
		tile.frame.clear()
	elif tile.ground.is_present():
		tile.ground.clear()
		
		
		
