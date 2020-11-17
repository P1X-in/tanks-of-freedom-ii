extends Control

const MAX_MAP_SIZE = 40

onready var map_list_service = $"/root/MapList"
onready var minimap = $"minimap"

var grass_tiles = ["ground_grass"]
var concrete_tiles = ["ground_concrete"]
var river_tiles = ["ground_river1", "ground_river2"]
var road_tiles = [
    "ground_road1",
    "ground_road2",
    "ground_road3",
    "ground_road4",
    "city_bridge",
]
var dirt_road_tiles = [
    "ground_dirt_road1",
    "ground_dirt_road2",
    "ground_dirt_road3",
    "ground_dirt_road4",
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
]
var mountain_tiles = [
    "nature_big_rocks1",
    "nature_big_rocks2",
    "nature_big_rocks3",
]
var forest_tiles = [
    "nature_trees1",
    "nature_trees2",
    "nature_trees3",
    "nature_trees4",
    "nature_trees5",
    "nature_trees6",
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


var cache = {}

func fill_minimap(map_name):
    var map_data = self.get_map_data(map_name)
    
    var key

    for y in range(self.MAX_MAP_SIZE):
        for x in range(self.MAX_MAP_SIZE):
            key = str(x) + "_" + str(y)
            if map_data["tiles"].has(key):
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

    if data["ground"]["tile"] in self.dirt_road_tiles:
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

func set_cell(x, y, id):
    self.minimap.set_cell(x, y, id)

func wipe():
    for y in range(self.MAX_MAP_SIZE):
        for x in range(self.MAX_MAP_SIZE):
            self.set_cell_from_data(x, y, null)
