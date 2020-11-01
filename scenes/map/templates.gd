
const GROUND_GRASS = "ground_grass"
const GROUND_CONCRETE = "ground_concrete"
const GROUND_RIVER1 = "ground_river1"
const GROUND_RIVER2 = "ground_river2"
const GROUND_ROAD1 = "ground_road1"
const GROUND_ROAD2 = "ground_road2"
const GROUND_ROAD3 = "ground_road3"
const GROUND_ROAD4 = "ground_road4"
const GROUND_DIRT_ROAD1 = "ground_dirt_road1"
const GROUND_DIRT_ROAD2 = "ground_dirt_road2"
const GROUND_DIRT_ROAD3 = "ground_dirt_road3"
const GROUND_DIRT_ROAD4 = "ground_dirt_road4"

const FRAME_GRASS1 = "frame_grass1"
const FRAME_GRASS2 = "frame_grass2"
const FRAME_GRASS3 = "frame_grass3"
const FRAME_GRASS4 = "frame_grass4"
const FRAME_RIVER1 = "frame_river1"
const FRAME_RIVER2 = "frame_river2"
const FRAME_RIVER3 = "frame_river3"
const FRAME_RIVER4 = "frame_river4"
const FRAME_ROAD1 = "frame_road1"
const FRAME_ROAD2 = "frame_road2"
const FRAME_ROAD3 = "frame_road3"
const FRAME_ROAD4 = "frame_road4"
const FRAME_FENCE = "frame_fence"

const DECO_FLOWERS1 = "deco_flower1"
const DECO_FLOWERS2 = "deco_flower2"
const DECO_FLOWERS3 = "deco_flower3"
const DECO_FLOWERS4 = "deco_flower4"
const DECO_FLOWERS5 = "deco_flower5"
const DECO_FLOWERS6 = "deco_flower6"
const DECO_FLOWERS7 = "deco_flower7"
const DECO_FOUNTAIN = "deco_fountain"
const DECO_LOG = "deco_log"
const DECO_ROCKS1 = "deco_rocks1"
const DECO_ROCKS2 = "deco_rocks2"
const DECO_STATUE = "deco_statue"

const CITY_BUILDING_BIG1 = "city_building_big1"
const CITY_BUILDING_BIG2 = "city_building_big2"
const CITY_BUILDING_BIG3 = "city_building_big3"
const CITY_BUILDING_BIG4 = "city_building_big4"
const CITY_BUILDING_SMALL1 = "city_building_small1"
const CITY_BUILDING_SMALL2 = "city_building_small2"
const CITY_BUILDING_SMALL3 = "city_building_small3"
const CITY_BUILDING_SMALL4 = "city_building_small4"
const CITY_BUILDING_SMALL5 = "city_building_small5"
const CITY_BUILDING_SMALL6 = "city_building_small6"
const CITY_BRIDGE = "city_bridge"

const NATURE_BIG_ROCKS1 = "nature_big_rocks1"
const NATURE_BIG_ROCKS2 = "nature_big_rocks2"
const NATURE_BIG_ROCKS3 = "nature_big_rocks3"
const NATURE_TREES1 = "nature_trees1"
const NATURE_TREES2 = "nature_trees2"
const NATURE_TREES3 = "nature_trees3"
const NATURE_TREES4 = "nature_trees4"
const NATURE_TREES5 = "nature_trees5"
const NATURE_TREES6 = "nature_trees6"

const MODERN_AIRFIELD = "modern_airfield"
const MODERN_BARRACKS = "modern_barracks"
const MODERN_FACTORY = "modern_factory"
const MODERN_HQ = "modern_hq"
const MODERN_TOWER = "modern_tower"


var templates = {
	self.GROUND_GRASS : preload("res://scenes/tiles/ground/grass.tscn"),
	self.GROUND_CONCRETE : preload("res://scenes/tiles/ground/concrete.tscn"),
	self.GROUND_RIVER1 : preload("res://scenes/tiles/ground/river1.tscn"),
	self.GROUND_RIVER2 : preload("res://scenes/tiles/ground/river2.tscn"),
	self.GROUND_ROAD1 : preload("res://scenes/tiles/ground/road1.tscn"),
	self.GROUND_ROAD2 : preload("res://scenes/tiles/ground/road2.tscn"),
	self.GROUND_ROAD3 : preload("res://scenes/tiles/ground/road3.tscn"),
	self.GROUND_ROAD4 : preload("res://scenes/tiles/ground/road4.tscn"),
	self.GROUND_DIRT_ROAD1 : preload("res://scenes/tiles/ground/dirt_road1.tscn"),
	self.GROUND_DIRT_ROAD2 : preload("res://scenes/tiles/ground/dirt_road2.tscn"),
	self.GROUND_DIRT_ROAD3 : preload("res://scenes/tiles/ground/dirt_road3.tscn"),
	self.GROUND_DIRT_ROAD4 : preload("res://scenes/tiles/ground/dirt_road4.tscn"),

	self.FRAME_GRASS1 : preload("res://scenes/tiles/frames/grass_1_overtile.tscn"),
	self.FRAME_GRASS2 : preload("res://scenes/tiles/frames/grass_2_overtile.tscn"),
	self.FRAME_GRASS3 : preload("res://scenes/tiles/frames/grass_3_overtile.tscn"),
	self.FRAME_GRASS4 : preload("res://scenes/tiles/frames/grass_4_overtile.tscn"),
	self.FRAME_RIVER1 : preload("res://scenes/tiles/frames/river_plants_1_overtile.tscn"),
	self.FRAME_RIVER2 : preload("res://scenes/tiles/frames/river_plants_2_overtile.tscn"),
	self.FRAME_RIVER3 : preload("res://scenes/tiles/frames/river_plants_3_overtile.tscn"),
	self.FRAME_RIVER4 : preload("res://scenes/tiles/frames/river_plants_4_overtile.tscn"),
	self.FRAME_ROAD1 : preload("res://scenes/tiles/frames/road_1_overtile.tscn"),
	self.FRAME_ROAD2 : preload("res://scenes/tiles/frames/road_2_overtile.tscn"),
	self.FRAME_ROAD3 : preload("res://scenes/tiles/frames/road_3_overtile.tscn"),
	self.FRAME_ROAD4 : preload("res://scenes/tiles/frames/road_4_overtile.tscn"),
	self.FRAME_FENCE : preload("res://scenes/tiles/frames/wired_fence_overtile.tscn"),

	self.DECO_FLOWERS1 : preload("res://scenes/tiles/decorations/flowers_1_overtile.tscn"),
	self.DECO_FLOWERS2 : preload("res://scenes/tiles/decorations/flowers_2_overtile.tscn"),
	self.DECO_FLOWERS3 : preload("res://scenes/tiles/decorations/flowers_3_overtile.tscn"),
	self.DECO_FLOWERS4 : preload("res://scenes/tiles/decorations/flowers_4_overtile.tscn"),
	self.DECO_FLOWERS5 : preload("res://scenes/tiles/decorations/flowers_5_overtile.tscn"),
	self.DECO_FLOWERS6 : preload("res://scenes/tiles/decorations/flowers_6_overtile.tscn"),
	self.DECO_FLOWERS7 : preload("res://scenes/tiles/decorations/flowers_7_overtile.tscn"),
	self.DECO_FOUNTAIN : preload("res://scenes/tiles/decorations/fountain_overtile.tscn"),
	self.DECO_LOG : preload("res://scenes/tiles/decorations/log_1_overtile.tscn"),
	self.DECO_ROCKS1 : preload("res://scenes/tiles/decorations/rocks_1_overtile.tscn"),
	self.DECO_ROCKS2 : preload("res://scenes/tiles/decorations/rocks_2_overtile.tscn"),
	self.DECO_STATUE : preload("res://scenes/tiles/decorations/statue_overtile.tscn"),

	self.CITY_BUILDING_BIG1 : preload("res://scenes/tiles/city/building_big_1_overtile.tscn"),
	self.CITY_BUILDING_BIG2 : preload("res://scenes/tiles/city/building_big_2_overtile.tscn"),
	self.CITY_BUILDING_BIG3 : preload("res://scenes/tiles/city/building_big_3_overtile.tscn"),
	self.CITY_BUILDING_BIG4 : preload("res://scenes/tiles/city/building_big_4_overtile.tscn"),
	self.CITY_BUILDING_SMALL1 : preload("res://scenes/tiles/city/building_small_1_overtile.tscn"),
	self.CITY_BUILDING_SMALL2 : preload("res://scenes/tiles/city/building_small_2_overtile.tscn"),
	self.CITY_BUILDING_SMALL3 : preload("res://scenes/tiles/city/building_small_3_overtile.tscn"),
	self.CITY_BUILDING_SMALL4 : preload("res://scenes/tiles/city/building_small_4_overtile.tscn"),
	self.CITY_BUILDING_SMALL5 : preload("res://scenes/tiles/city/building_small_5_overtile.tscn"),
	self.CITY_BUILDING_SMALL6 : preload("res://scenes/tiles/city/building_small_6_overtile.tscn"),
	self.CITY_BRIDGE : preload("res://scenes/tiles/city/river_bridge_overtile.tscn"),

	self.NATURE_BIG_ROCKS1 : preload("res://scenes/tiles/nature/big_rocks_1_overtile.tscn"),
	self.NATURE_BIG_ROCKS2 : preload("res://scenes/tiles/nature/big_rocks_2_overtile.tscn"),
	self.NATURE_BIG_ROCKS3 : preload("res://scenes/tiles/nature/big_rocks_3_overtile.tscn"),
	self.NATURE_TREES1 : preload("res://scenes/tiles/nature/trees_1_overtile.tscn"),
	self.NATURE_TREES2 : preload("res://scenes/tiles/nature/trees_2_overtile.tscn"),
	self.NATURE_TREES3 : preload("res://scenes/tiles/nature/trees_3_overtile.tscn"),
	self.NATURE_TREES4 : preload("res://scenes/tiles/nature/trees_4_overtile.tscn"),
	self.NATURE_TREES5 : preload("res://scenes/tiles/nature/trees_5_overtile.tscn"),
	self.NATURE_TREES6 : preload("res://scenes/tiles/nature/trees_6_overtile.tscn"),

	self.MODERN_AIRFIELD : preload("res://scenes/tiles/buildings/blue/airfield.tscn"),
	self.MODERN_BARRACKS : preload("res://scenes/tiles/buildings/blue/barracks.tscn"),
	self.MODERN_FACTORY : preload("res://scenes/tiles/buildings/blue/factory.tscn"),
	self.MODERN_HQ : preload("res://scenes/tiles/buildings/blue/headquarters.tscn"),
	self.MODERN_TOWER : preload("res://scenes/tiles/buildings/blue/tower.tscn"),
}

func get_template(template):
	return self.templates[template].instance()