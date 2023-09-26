extends Control

@onready var map_list_service = $"/root/MapManager"
@onready var minimap = $"minimap"

var grass_tiles = ["ground_grass"]
var snow_tiles = ["ground_snow"]
var sand_tiles = ["ground_sand", "frame_wheat"]
var concrete_tiles = ["ground_concrete"]
var river_tiles = [
	"ground_river1", 
	"ground_river2", 
	"ground_snow_river1",
	"ground_snow_river2",
	"ground_sand_river1",
	"ground_sand_river2",
	"ground_swamp",
	"ground_swamp2",
	"ground_swamp3",
]
var road_tiles = [
	"ground_road1",
	"ground_road2",
	"ground_road3",
	"ground_road4",
	"city_bridge",
	"ground_snow_road1",
	"ground_snow_road2",
	"ground_snow_road3",
	"ground_snow_road4",
	"ground_sand_road1",
	"ground_sand_road2",
	"ground_sand_road3",
	"ground_sand_road4",
	"bridge_plate",
	"bridge_legs",
	"ground_road_transition",
	"ground_road_transition2",
	"ground_road_transition3",
	"ground_road_transition4",
	"ground_snow_road_transition",
	"ground_snow_road_transition2",
	"ground_snow_road_transition3",
	"ground_snow_road_transition4",
	"ground_sand_road_transition",
	"ground_sand_road_transition2",
	"ground_sand_road_transition3",
	"ground_sand_road_transition4",
]
var dirt_road_tiles = [
	"ground_dirt_road1",
	"ground_dirt_road2",
	"ground_dirt_road3",
	"ground_dirt_road4",
	"city_bridge_wood",
	"bridge_stone",
	"ground_mud",
	"deco_rail_straight",
	"deco_rail_turn",
	"deco_rail_t",
	"deco_rail_cross",
	"deco_rail_end",
]
var city_tiles = [
	"city_building_big1",
	"city_building_big2",
	"city_building_big3",
	"city_building_big4",
	"city_building_small1",
	"city_building_small2",
	"city_building_small3",
	"city_building_small4",
	"city_building_small5",
	"city_building_small6",
	"city_shop1",
	"city_shop2",
	"city_shop3",
	"deco_fountain",
	"deco_statue",
	"deco_statue_rat",
	"deco_statue_capsule",
	"damaged_statue",
	"damaged_statue_rat",
	"damaged_statue_capsule",
	"damaged_fountain",
	"damaged_building_small1",
	"damaged_building_small2",
	"damaged_building_small3",
	"damaged_building_small4",
	"damaged_building_small5",
	"damaged_building_small6",
	"damaged_building_big1",
	"damaged_building_big2",
	"damaged_building_big3",
	"damaged_building_big4",
	"damaged_shop1",
	"damaged_shop2",
	"damaged_shop3",
	"destroyed_building_small1",
	"destroyed_building_small2",
	"destroyed_building_small3",
	"destroyed_building_small4",
	"destroyed_building_small5",
	"destroyed_building_small6",
	"destroyed_building_big1",
	"destroyed_building_big2",
	"destroyed_building_big3",
	"destroyed_building_big4",
	"destroyed_shop1",
	"destroyed_shop2",
	"destroyed_shop3",
	"destroyed_statue",
	"destroyed_statue_rat",
	"destroyed_statue_capsule",
	"destroyed_fountain",
	"castle_wall_straight",
	"castle_wall_straight2",
	"castle_wall_corner",
	"castle_wall_cross",
	"castle_wall_t",
	"castle_wall_t2",
	"castle_wall_gate",
	"castle_wall_gate_closed",
]
var mountain_tiles = [
	"nature_big_rocks1",
	"nature_big_rocks2",
	"nature_big_rocks3",
	"nature_big_rocks4",
]
var forest_tiles = [
	"nature_trees1",
	"nature_trees2",
	"nature_trees3",
	"nature_trees4",
	"nature_trees5",
	"nature_trees6",
	"nature_trees10",
	"nature_trees11",
	"nature_trees12",
	"nature_trees13",
	"nature_trees16",
	"nature_trees17",
	"nature_trees18",
]

var forest_autumn_tiles = [
	"nature_trees7",
	"nature_trees8",
	"nature_trees9",
	"nature_trees14",
	"nature_trees15",
]

var cacti_tiles = [
	"nature_sand_cacti1",
	"nature_sand_cacti2",
	"nature_sand_cacti3",
	"nature_sand_palms1",
	"nature_sand_palms2",
	"nature_sand_palms3",
	"nature_sand_palms4",
]

var dune_tiles = [
	"nature_sand_dunes1",
	"nature_sand_dunes2",
	"nature_sand_dunes3",
	"nature_sand_dunes4",
]


const TILE_BUILDING = 0
const TILE_CITY = 1
const TILE_CONCRETE = 2
const TILE_DIRT_ROAD = 3
const TILE_FOREST = 4
const TILE_GRASS = 5
const TILE_MOUNTAIN = 6
const TILE_RIVER = 7
const TILE_ROAD = 8
const TILE_WATER = 9
const TILE_SNOW = 10
const TILE_SAND = 11
const TILE_AUTUMN = 12
const TILE_DUNES = 13
const TILE_CACTI = 14


var cache = {}

func fill_minimap(map_name):
	var map_data = self.get_map_data(map_name)
	
	var key

	for y in range(self.map_list_service.MAX_MAP_SIZE):
		for x in range(self.map_list_service.MAX_MAP_SIZE):
			key = str(x) + "_" + str(y)
			if map_data.has("tiles") and map_data["tiles"].has(key):
				self.set_cell_from_data(x, y, map_data["tiles"][key])
			else:
				self.set_cell_from_data(x, y, null)


func get_map_data(map_name):
	if self.cache.has(map_name):
		return self.cache[map_name]

	var map_data = self.map_list_service.get_map_data(map_name)

	self.cache[map_name] = map_data

	return map_data

func remove_from_cache(map_name):
	if self.cache.has(map_name):
		self.cache.erase(map_name)

func set_cell_from_data(x, y, data):
	if data == null:
		self.set_cell(x, y, self.TILE_WATER)
		return

	if data["building"]["tile"] != null:
		self.set_cell(x, y, self.TILE_BUILDING)
		return

	if data["terrain"]["tile"] in self.city_tiles:
		self.set_cell(x, y, self.TILE_CITY)
		return

	if data["terrain"]["tile"] in self.mountain_tiles:
		self.set_cell(x, y, self.TILE_MOUNTAIN)
		return

	if data["terrain"]["tile"] in self.forest_tiles:
		self.set_cell(x, y, self.TILE_FOREST)
		return

	if data["terrain"]["tile"] in self.forest_autumn_tiles:
		self.set_cell(x, y, self.TILE_AUTUMN)
		return

	if data["terrain"]["tile"] in self.dune_tiles:
		self.set_cell(x, y, self.TILE_DUNES)
		return

	if data["terrain"]["tile"] in self.cacti_tiles:
		self.set_cell(x, y, self.TILE_CACTI)
		return

	if data["ground"]["tile"] in self.dirt_road_tiles || data["terrain"]["tile"] in self.dirt_road_tiles:
		self.set_cell(x, y, self.TILE_DIRT_ROAD)
		return

	if data["ground"]["tile"] in self.road_tiles || data["terrain"]["tile"] in self.road_tiles:
		self.set_cell(x, y, self.TILE_ROAD)
		return

	if data["ground"]["tile"] in self.river_tiles:
		self.set_cell(x, y, self.TILE_RIVER)
		return

	if data["ground"]["tile"] in self.concrete_tiles:
		self.set_cell(x, y, self.TILE_CONCRETE)
		return

	if data["ground"]["tile"] in self.grass_tiles:
		self.set_cell(x, y, self.TILE_GRASS)
		return

	if data["ground"]["tile"] in self.snow_tiles:
		self.set_cell(x, y, self.TILE_SNOW)
		return

	if data["ground"]["tile"] in self.sand_tiles:
		self.set_cell(x, y, self.TILE_SAND)
		return

	#fallback for undefined tiles
	self.set_cell(x, y, self.TILE_WATER)

func set_cell(x, y, id):
	self.minimap.set_cell(0, Vector2i(x, y), id, Vector2i(0, 0))

func wipe():
	for y in range(self.map_list_service.MAX_MAP_SIZE):
		for x in range(self.map_list_service.MAX_MAP_SIZE):
			self.set_cell_from_data(x, y, null)
