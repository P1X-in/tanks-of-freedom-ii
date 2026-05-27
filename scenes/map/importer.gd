const TERRAIN_PLAIN = 0
const TERRAIN_FOREST = 1
const TERRAIN_MOUNTAINS = 2
const TERRAIN_RIVER = 3
const TERRAIN_CITY = 4
const TERRAIN_CITY_DESTROYED = 33
const TERRAIN_ROAD = 5
const TERRAIN_DIRT_ROAD = 6
const TERRAIN_DIRT = 7
const TERRAIN_BRIDGE = 8
const TERRAIN_FENCE = 9
const TERRAIN_STATUE = 10
const TERRAIN_HQ_BLUE = 11
const TERRAIN_HQ_RED = 12
const TERRAIN_BARRACKS_FREE = 13
const TERRAIN_FACTORY_FREE = 14
const TERRAIN_AIRPORT_FREE = 15
const TERRAIN_TOWER_FREE = 16
const TERRAIN_SPAWN = 17
const ICON_EREASE = 18
const TERRAIN_BARRACKS_RED = 19
const TERRAIN_FACTORY_RED = 20
const TERRAIN_AIRPORT_RED = 21
const TERRAIN_TOWER_RED = 22
const TERRAIN_BARRACKS_BLUE = 23
const TERRAIN_FACTORY_BLUE = 24
const TERRAIN_AIRPORT_BLUE = 25
const TERRAIN_TOWER_BLUE = 26
const UNIT_INFANTRY_BLUE = 27
const UNIT_TANK_BLUE = 28
const UNIT_HELICOPTER_BLUE = 29
const UNIT_INFANTRY_RED = 30
const UNIT_TANK_RED = 31
const UNIT_HELICOPTER_RED = 32
const TERRAIN_CONCRETE = 34
const UNIT_CIVILIAN = 35


var mappings = {
    "summer": {
        self.TERRAIN_PLAIN : {"ground": "ground_grass"},
        self.TERRAIN_FOREST : {"ground": "ground_grass", "terrain": "nature_trees1"},
        self.TERRAIN_MOUNTAINS : {"ground": "ground_snow", "terrain": "nature_big_rocks2"},
        self.TERRAIN_RIVER : {"ground": "ground_river1"},
        self.TERRAIN_CITY : {"ground": "ground_grass", "terrain": "city_building_big1"},
        self.TERRAIN_CITY_DESTROYED : {"ground": "ground_grass", "terrain": "destroyed_building_big1"},
        self.TERRAIN_ROAD : {"ground": "ground_road1"},
        self.TERRAIN_DIRT_ROAD : {"ground": "ground_dirt_road1"},
        self.TERRAIN_DIRT : {"ground": "ground_mud"},
        self.TERRAIN_BRIDGE : {"ground": "ground_river1", "terrain": "city_bridge"},
        self.TERRAIN_FENCE : {"ground": "ground_concrete"},
        self.TERRAIN_STATUE : {"ground": "ground_concrete", "terrain": "deco_statue"},
        self.TERRAIN_HQ_BLUE : {"ground": "ground_grass", "building": "modern_hq"},
        self.TERRAIN_HQ_RED : {"ground": "ground_grass", "building": "steampunk_hq"},
        self.TERRAIN_BARRACKS_FREE : {"ground": "ground_grass", "building": "modern_barracks", "side": "neutral"},
        self.TERRAIN_FACTORY_FREE : {"ground": "ground_grass", "building": "modern_factory", "side": "neutral"},
        self.TERRAIN_AIRPORT_FREE : {"ground": "ground_grass", "building": "modern_airfield", "side": "neutral"},
        self.TERRAIN_TOWER_FREE : {"ground": "ground_grass", "building": "modern_tower", "side": "neutral"},
        self.TERRAIN_SPAWN : {"ground": "ground_concrete"},
        self.ICON_EREASE : {"ground": "ground_grass"},
        self.TERRAIN_BARRACKS_RED : {"ground": "ground_grass", "building": "steampunk_barracks"},
        self.TERRAIN_FACTORY_RED : {"ground": "ground_grass", "building": "steampunk_factory"},
        self.TERRAIN_AIRPORT_RED : {"ground": "ground_grass", "building": "steampunk_airfield"},
        self.TERRAIN_TOWER_RED : {"ground": "ground_grass", "building": "steampunk_tower"},
        self.TERRAIN_BARRACKS_BLUE : {"ground": "ground_grass", "building": "modern_barracks"},
        self.TERRAIN_FACTORY_BLUE : {"ground": "ground_grass", "building": "modern_factory"},
        self.TERRAIN_AIRPORT_BLUE : {"ground": "ground_grass", "building": "modern_airfield"},
        self.TERRAIN_TOWER_BLUE : {"ground": "ground_grass", "building": "modern_tower"},
        self.UNIT_INFANTRY_BLUE : {"ground": "ground_grass", "unit": "blue_infantry"},
        self.UNIT_TANK_BLUE : {"ground": "ground_grass", "unit": "blue_tank"},
        self.UNIT_HELICOPTER_BLUE : {"ground": "ground_grass", "unit": "blue_heli"},
        self.UNIT_INFANTRY_RED : {"ground": "ground_grass", "unit": "red_infantry"},
        self.UNIT_TANK_RED : {"ground": "ground_grass", "unit": "red_tank"},
        self.UNIT_HELICOPTER_RED : {"ground": "ground_grass", "unit": "red_heli"},
        self.TERRAIN_CONCRETE : {"ground": "ground_concrete", "terrain": null, "unit": null, "building": null},
        self.UNIT_CIVILIAN : {"ground": "ground_grass"},
    },
    "winter": {
        self.TERRAIN_PLAIN : {"ground": "ground_snow"},
        self.TERRAIN_FOREST : {"ground": "ground_snow", "terrain": "nature_trees4"},
        self.TERRAIN_MOUNTAINS : {"ground": "ground_snow", "terrain": "nature_big_rocks2"},
        self.TERRAIN_RIVER : {"ground": "ground_snow_river1"},
        self.TERRAIN_CITY : {"ground": "ground_snow", "terrain": "city_building_big1"},
        self.TERRAIN_CITY_DESTROYED : {"ground": "ground_snow", "terrain": "destroyed_building_big1"},
        self.TERRAIN_ROAD : {"ground": "ground_snow_road1"},
        self.TERRAIN_DIRT_ROAD : {"ground": "ground_snow_dirt_road1"},
        self.TERRAIN_DIRT : {"ground": "ground_mud"},
        self.TERRAIN_BRIDGE : {"ground": "ground_snow_river1", "terrain": "city_bridge"},
        self.TERRAIN_FENCE : {"ground": "ground_concrete"},
        self.TERRAIN_STATUE : {"ground": "ground_concrete", "terrain": "deco_statue"},
        self.TERRAIN_HQ_BLUE : {"ground": "ground_snow", "building": "modern_hq"},
        self.TERRAIN_HQ_RED : {"ground": "ground_snow", "building": "steampunk_hq"},
        self.TERRAIN_BARRACKS_FREE : {"ground": "ground_snow", "building": "modern_barracks", "side": "neutral"},
        self.TERRAIN_FACTORY_FREE : {"ground": "ground_snow", "building": "modern_factory", "side": "neutral"},
        self.TERRAIN_AIRPORT_FREE : {"ground": "ground_snow", "building": "modern_airfield", "side": "neutral"},
        self.TERRAIN_TOWER_FREE : {"ground": "ground_snow", "building": "modern_tower", "side": "neutral"},
        self.TERRAIN_SPAWN : {"ground": "ground_concrete"},
        self.ICON_EREASE : {"ground": "ground_snow"},
        self.TERRAIN_BARRACKS_RED : {"ground": "ground_snow", "building": "steampunk_barracks"},
        self.TERRAIN_FACTORY_RED : {"ground": "ground_snow", "building": "steampunk_factory"},
        self.TERRAIN_AIRPORT_RED : {"ground": "ground_snow", "building": "steampunk_airfield"},
        self.TERRAIN_TOWER_RED : {"ground": "ground_snow", "building": "steampunk_tower"},
        self.TERRAIN_BARRACKS_BLUE : {"ground": "ground_snow", "building": "modern_barracks"},
        self.TERRAIN_FACTORY_BLUE : {"ground": "ground_snow", "building": "modern_factory"},
        self.TERRAIN_AIRPORT_BLUE : {"ground": "ground_snow", "building": "modern_airfield"},
        self.TERRAIN_TOWER_BLUE : {"ground": "ground_snow", "building": "modern_tower"},
        self.UNIT_INFANTRY_BLUE : {"ground": "ground_snow", "unit": "blue_infantry"},
        self.UNIT_TANK_BLUE : {"ground": "ground_snow", "unit": "blue_tank"},
        self.UNIT_HELICOPTER_BLUE : {"ground": "ground_snow", "unit": "blue_heli"},
        self.UNIT_INFANTRY_RED : {"ground": "ground_snow", "unit": "red_infantry"},
        self.UNIT_TANK_RED : {"ground": "ground_snow", "unit": "red_tank"},
        self.UNIT_HELICOPTER_RED : {"ground": "ground_snow", "unit": "red_heli"},
        self.TERRAIN_CONCRETE : {"ground": "ground_concrete", "terrain": null, "unit": null, "building": null},
        self.UNIT_CIVILIAN : {"ground": "ground_snow"},
    },
    "fall": {
        self.TERRAIN_PLAIN : {"ground": "ground_grass"},
        self.TERRAIN_FOREST : {"ground": "ground_grass", "terrain": "nature_trees7"},
        self.TERRAIN_MOUNTAINS : {"ground": "ground_snow", "terrain": "nature_big_rocks2"},
        self.TERRAIN_RIVER : {"ground": "ground_river1"},
        self.TERRAIN_CITY : {"ground": "ground_grass", "terrain": "city_building_big1"},
        self.TERRAIN_CITY_DESTROYED : {"ground": "ground_grass", "terrain": "destroyed_building_big1"},
        self.TERRAIN_ROAD : {"ground": "ground_road1"},
        self.TERRAIN_DIRT_ROAD : {"ground": "ground_dirt_road1"},
        self.TERRAIN_DIRT : {"ground": "ground_mud"},
        self.TERRAIN_BRIDGE : {"ground": "ground_river1", "terrain": "city_bridge"},
        self.TERRAIN_FENCE : {"ground": "ground_concrete"},
        self.TERRAIN_STATUE : {"ground": "ground_concrete", "terrain": "deco_statue"},
        self.TERRAIN_HQ_BLUE : {"ground": "ground_grass", "building": "modern_hq"},
        self.TERRAIN_HQ_RED : {"ground": "ground_grass", "building": "steampunk_hq"},
        self.TERRAIN_BARRACKS_FREE : {"ground": "ground_grass", "building": "modern_barracks", "side": "neutral"},
        self.TERRAIN_FACTORY_FREE : {"ground": "ground_grass", "building": "modern_factory", "side": "neutral"},
        self.TERRAIN_AIRPORT_FREE : {"ground": "ground_grass", "building": "modern_airfield", "side": "neutral"},
        self.TERRAIN_TOWER_FREE : {"ground": "ground_grass", "building": "modern_tower", "side": "neutral"},
        self.TERRAIN_SPAWN : {"ground": "ground_concrete"},
        self.ICON_EREASE : {"ground": "ground_grass"},
        self.TERRAIN_BARRACKS_RED : {"ground": "ground_grass", "building": "steampunk_barracks"},
        self.TERRAIN_FACTORY_RED : {"ground": "ground_grass", "building": "steampunk_factory"},
        self.TERRAIN_AIRPORT_RED : {"ground": "ground_grass", "building": "steampunk_airfield"},
        self.TERRAIN_TOWER_RED : {"ground": "ground_grass", "building": "steampunk_tower"},
        self.TERRAIN_BARRACKS_BLUE : {"ground": "ground_grass", "building": "modern_barracks"},
        self.TERRAIN_FACTORY_BLUE : {"ground": "ground_grass", "building": "modern_factory"},
        self.TERRAIN_AIRPORT_BLUE : {"ground": "ground_grass", "building": "modern_airfield"},
        self.TERRAIN_TOWER_BLUE : {"ground": "ground_grass", "building": "modern_tower"},
        self.UNIT_INFANTRY_BLUE : {"ground": "ground_grass", "unit": "blue_infantry"},
        self.UNIT_TANK_BLUE : {"ground": "ground_grass", "unit": "blue_tank"},
        self.UNIT_HELICOPTER_BLUE : {"ground": "ground_grass", "unit": "blue_heli"},
        self.UNIT_INFANTRY_RED : {"ground": "ground_grass", "unit": "red_infantry"},
        self.UNIT_TANK_RED : {"ground": "ground_grass", "unit": "red_tank"},
        self.UNIT_HELICOPTER_RED : {"ground": "ground_grass", "unit": "red_heli"},
        self.TERRAIN_CONCRETE : {"ground": "ground_concrete", "terrain": null, "unit": null, "building": null},
        self.UNIT_CIVILIAN : {"ground": "ground_grass"},
    },
}

var units = [
    "blue_infantry",
    "blue_tank",
    "blue_heli",
    "red_infantry",
    "red_tank",
    "red_heli",
]

func build_from_v1_data(map, data):
    self._fill_metadata(map, data)

    if not data["data"].has("theme"):
        data["data"]["theme"] = "summer"

    self._build_tiles(map, data["data"]["tiles"], data["data"]["theme"])
    self._fix_map_elements(map)

func _fill_metadata(map, data):
    map.model.ingest_scripts({
        "stories" : {},
        "triggers" : {}
    })
    map.model.metadata["name"] = data["data"]["name"]
    map.model.metadata["iteration"] = 0
    map.model.metadata["base_code"] = data["code"]

func _build_tiles(map, tiles, theme):
    var tilemap = self.mappings[theme]
    self._pre_fill_tilemap(map, tilemap, tiles)

func _pre_fill_tilemap(map, tilemap, tiles):
    var tile_key
    var tile_template
    var mapping
    var unit

    for tile_data in tiles:
        tile_key = str(tile_data["x"]) + "_" + str(tile_data["y"])
        mapping = tilemap[int(tile_data["terrain"])]
        unit = int(tile_data["unit"])

        tile_template = {
            "building": {
                "abilities": {
                    "ability0": true,
                    "ability2": false,
                    "ability4": true
                },
                "rotation": 0,
                "side": null,
                "tile": null
            },
            "damage": {
                "rotation": 0,
                "tile": null
            },
            "decoration": {
                "rotation": 0,
                "tile": null
            },
            "frame": {
                "rotation": 0,
                "tile": null
            },
            "ground": {
                "rotation": 0,
                "tile": null
            },
            "terrain": {
                "rotation": 0,
                "tile": null
            },
            "unit": {
                "modifiers": {},
                "rotation": 0,
                "side": null,
                "tile": null
            }
        }

        tile_template["ground"]["tile"] = mapping["ground"]
        if mapping.has("terrain"):
            tile_template["terrain"]["tile"] = mapping["terrain"]
        if mapping.has("building"):
            tile_template["building"]["tile"] = mapping["building"]
        if mapping.has("side"):
            tile_template["building"]["side"] = mapping["side"]
        if mapping.has("unit"):
            tile_template["unit"]["tile"] = mapping["unit"]

        if unit > -1 and unit < 6:
            tile_template["unit"]["tile"] = self.units[unit]

        map.builder.place_tile(tile_key, tile_template)

func _fix_map_elements(map):
    for tile in map.model.tiles.values():
        self._fix_land_bridges(map, tile)
        self._fix_city_buildings(map, tile)
        self._fix_roads_and_rivers(map, tile)
        self._fix_road_bridges(map, tile)

func _fix_land_bridges(map, tile):
    if not tile.ground.is_present():
        return

    var watched_types = [
        "ground_grass",
        "ground_mud",
        "ground_snow",
        "ground_dirt_road1",
        "ground_snow_dirt_road1",
    ]

    if watched_types.has(tile.ground.tile.template_name):
        var e = tile.get_neighbour("e")
        var w = tile.get_neighbour("w")
        var n = tile.get_neighbour("n")
        var s = tile.get_neighbour("s")

        if n != null and n.ground.is_present() and s != null and s.ground.is_present() and e != null and not e.ground.is_present() and w != null and not w.ground.is_present():
            map.builder.place_ground(tile.position, "bridge_stone", 0)
            map.builder.place_terrain(tile.position, "bridge_stone_barrier", 0)

        if n != null and not n.ground.is_present() and s != null and not s.ground.is_present() and e != null and e.ground.is_present() and w != null and w.ground.is_present():
            map.builder.place_ground(tile.position, "bridge_stone", 90)
            map.builder.place_terrain(tile.position, "bridge_stone_barrier", 90)

func _fix_road_bridges(map, tile):
    if not tile.ground.is_present():
        return

    var watched_types = [
        "ground_road1",
        "ground_snow_road1",
    ]

    if watched_types.has(tile.ground.tile.template_name):
        var e = tile.get_neighbour("e")
        var w = tile.get_neighbour("w")
        var n = tile.get_neighbour("n")
        var s = tile.get_neighbour("s")

        if n != null and n.ground.is_present() and s != null and s.ground.is_present() and e != null and not e.ground.is_present() and w != null and not w.ground.is_present():
            map.builder.place_ground(tile.position, "bridge_legs", 0)
            map.builder.place_terrain(tile.position, "bridge_suspension", 0)

        if n != null and not n.ground.is_present() and s != null and not s.ground.is_present() and e != null and e.ground.is_present() and w != null and w.ground.is_present():
            map.builder.place_ground(tile.position, "bridge_legs", 90)
            map.builder.place_terrain(tile.position, "bridge_suspension", 90)


func _fix_city_buildings(map, tile):
    if not tile.terrain.is_present():
        return

    if tile.terrain.tile.template_name != "city_building_big1" and tile.terrain.tile.template_name != "destroyed_building_big1":
        return

    var small_neighbours = self._count_neighbours(map, tile, [
        "ground_road1",
        "ground_dirt_road1",
        "ground_snow_road1",
        "ground_snow_dirt_road1",
        "ground_river1",
        "ground_snow_river1",
    ])
    var city_neighbours = self._count_neighbours(map, tile, [
        "city_building_big1",
        "destroyed_building_big1",
        "city_building_small4",
        "destroyed_building_small4",
    ])

    if small_neighbours > 0 or city_neighbours < 5:
        if tile.terrain.tile.template_name == "city_building_big1":
            map.builder.place_terrain(tile.position, "city_building_small4", 0)
        if tile.terrain.tile.template_name == "destroyed_building_big1":
            map.builder.place_terrain(tile.position, "destroyed_building_small4", 0)



func _fix_roads_and_rivers(map, tile):
    if not tile.ground.is_present():
        return

    var roads = [
        "ground_road1",
        "ground_snow_road1",
    ]
    var dirt_roads = [
        "ground_dirt_road1",
        "ground_snow_dirt_road1",
    ]
    var rivers = [
        "ground_river1",
        "ground_snow_river1",
    ]

    var affected_tile_types = roads + dirt_roads + rivers

    if not affected_tile_types.has(tile.ground.tile.template_name):
        return

    if roads.has(tile.ground.tile.template_name):
        if tile.ground.tile.template_name == "ground_road1":
            self._fix_path_element(map, tile, [
                "ground_road1",
                "ground_road2",
                "ground_road3",
                "ground_road4",
            ], [
                "ground_road1",
                "ground_road2",
                "ground_road3",
                "ground_road4",
                "ground_snow_road1",
                "ground_snow_road2",
                "ground_snow_road3",
                "ground_snow_road4",
                "ground_dirt_road1",
                "ground_dirt_road2",
                "ground_dirt_road3",
                "ground_dirt_road4",
                "ground_snow_dirt_road1",
                "ground_snow_dirt_road2",
                "ground_snow_dirt_road3",
                "ground_snow_dirt_road4",
                "city_bridge",
                "city_bridge_wood",
                "bridge_stone",
                "bridge_legs",
            ])
        if tile.ground.tile.template_name == "ground_snow_road1":
            self._fix_path_element(map, tile, [
                "ground_snow_road1",
                "ground_snow_road2",
                "ground_snow_road3",
                "ground_snow_road4",
            ], [
                "ground_road1",
                "ground_road2",
                "ground_road3",
                "ground_road4",
                "ground_snow_road1",
                "ground_snow_road2",
                "ground_snow_road3",
                "ground_snow_road4",
                "ground_dirt_road1",
                "ground_dirt_road2",
                "ground_dirt_road3",
                "ground_dirt_road4",
                "ground_snow_dirt_road1",
                "ground_snow_dirt_road2",
                "ground_snow_dirt_road3",
                "ground_snow_dirt_road4",
                "city_bridge",
                "city_bridge_wood",
                "bridge_stone",
                "bridge_legs",
            ])

    if dirt_roads.has(tile.ground.tile.template_name):
        if tile.ground.tile.template_name == "ground_dirt_road1":
            self._fix_path_element(map, tile, [
                "ground_dirt_road1",
                "ground_dirt_road2",
                "ground_dirt_road3",
                "ground_dirt_road4",
            ], [
                "ground_road1",
                "ground_road2",
                "ground_road3",
                "ground_road4",
                "ground_snow_road1",
                "ground_snow_road2",
                "ground_snow_road3",
                "ground_snow_road4",
                "ground_dirt_road1",
                "ground_dirt_road2",
                "ground_dirt_road3",
                "ground_dirt_road4",
                "ground_snow_dirt_road1",
                "ground_snow_dirt_road2",
                "ground_snow_dirt_road3",
                "ground_snow_dirt_road4",
                "city_bridge",
                "city_bridge_wood",
                "bridge_stone",
                "bridge_legs",
            ])
        if tile.ground.tile.template_name == "ground_snow_dirt_road1":
            self._fix_path_element(map, tile, [
                "ground_snow_dirt_road1",
                "ground_snow_dirt_road2",
                "ground_snow_dirt_road3",
                "ground_snow_dirt_road4",
            ], [
                "ground_road1",
                "ground_road2",
                "ground_road3",
                "ground_road4",
                "ground_snow_road1",
                "ground_snow_road2",
                "ground_snow_road3",
                "ground_snow_road4",
                "ground_dirt_road1",
                "ground_dirt_road2",
                "ground_dirt_road3",
                "ground_dirt_road4",
                "ground_snow_dirt_road1",
                "ground_snow_dirt_road2",
                "ground_snow_dirt_road3",
                "ground_snow_dirt_road4",
                "city_bridge",
                "city_bridge_wood",
                "bridge_stone",
                "bridge_legs",
            ])

    if rivers.has(tile.ground.tile.template_name):
        if tile.ground.tile.template_name == "ground_river1":
            self._fix_path_element(map, tile, [
                "ground_river1",
                "ground_river2",
                null,
                null,
            ], [
                "ground_river1",
                "ground_river2",
                "ground_snow_river1",
                "ground_snow_river2",
            ])
        if tile.ground.tile.template_name == "ground_snow_river1":
            self._fix_path_element(map, tile, [
                "ground_snow_river1",
                "ground_snow_river2",
                null,
                null,
            ], [
                "ground_river1",
                "ground_river2",
                "ground_snow_river1",
                "ground_snow_river2",
            ])


func _fix_path_element(map, tile, templates, neighbours):
    var nbin = 0
    nbin = self._count_neighbours_in_binary(tile, neighbours)
    if nbin in [1, 4, 5]:
        map.builder.place_ground(tile.position, templates[0], 0)
        if tile.terrain.is_present() and tile.terrain.tile.template_name == "city_bridge":
            map.builder.place_terrain(tile.position, "city_bridge", 0)
        return
    if nbin in [2, 8, 10]:
        map.builder.place_ground(tile.position, templates[0], 90)
        if tile.terrain.is_present() and tile.terrain.tile.template_name == "city_bridge":
            map.builder.place_terrain(tile.position, "city_bridge", 90)
        return
    if nbin == 6:
        map.builder.place_ground(tile.position, templates[1], 0)
        return
    if nbin == 12:
        map.builder.place_ground(tile.position, templates[1], 270)
        return
    if nbin == 9:
        map.builder.place_ground(tile.position, templates[1], 180)
        return
    if nbin == 3:
        map.builder.place_ground(tile.position, templates[1], 90)
        return
    if nbin == 7 and templates[2] != null:
        map.builder.place_ground(tile.position, templates[2], 0)
        return
    if nbin == 11 and templates[2] != null:
        map.builder.place_ground(tile.position, templates[2], 90)
        return
    if nbin == 13 and templates[2] != null:
        map.builder.place_ground(tile.position, templates[2], 180)
        return
    if nbin == 14 and templates[2] != null:
        map.builder.place_ground(tile.position, templates[2], 270)
        return
    if nbin == 15 and templates[3] != null:
        map.builder.place_ground(tile.position, templates[3], 0)
        return

func _count_neighbours_in_binary(tile, templates):
    var count = 0
    count += self._lookup_neighbour(tile, templates, "n", 1)
    count += self._lookup_neighbour(tile, templates, "e", 2)
    count += self._lookup_neighbour(tile, templates, "s", 4)
    count += self._lookup_neighbour(tile, templates, "w", 8)
    return count

func _lookup_neighbour(tile, templates, direction, value):
    var neighbour = tile.get_neighbour(direction)
    if neighbour == null:
        return 0
    if neighbour.ground.is_present() and templates.has(neighbour.ground.tile.template_name):
        return value
    if neighbour.terrain.is_present() and templates.has(neighbour.terrain.tile.template_name):
        return value
    return 0

func _count_neighbours(map, tile, templates):
    var count = 0
    var neighbour

    for x in range(3):
        for y in range(3):
            if x == 1 and y == 1:
                continue
            neighbour = map.model.get_tile(Vector2(tile.position.x - 1 + x, tile.position.y - 1 + y))
            if neighbour != null:
                if neighbour.ground.is_present():
                    if templates.has(neighbour.ground.tile.template_name):
                        count += 1
                if neighbour.terrain.is_present():
                    if templates.has(neighbour.terrain.tile.template_name):
                        count += 1
    return count
