
var visited_tiles = {}
var explored_tiles = {}
var tile_path = {}

var enemy_units = {}
var enemy_buildings = {}
var own_units = {}
var own_buildings = {}
var allied_units = {}
var allied_buildings = {}

func reset():
    self.visited_tiles = {}
    self.explored_tiles = {}
    self.tile_path = {}
    self.enemy_units = {}
    self.enemy_buildings = {}
    self.own_units = {}
    self.own_buildings = {}
    self.allied_units = {}
    self.allied_buildings = {}

func explore(source_tile, distance):
    self.reset()
    self.add_path_root(source_tile)
    self.expand_from_tile(source_tile, distance, 0, source_tile.unit.tile)

func mark_tile_cost(tile, cost):
    self.visited_tiles[self._get_key(tile)] = tile
    self.explored_tiles[self._get_key(tile)] = cost

func get_tile_cost(tile):
    var key = self._get_key(tile)
    if self.explored_tiles.has(key):
        return self.explored_tiles[key]

    return null

func expand_from_tile(tile, depth, reach_cost, unit):
    self.mark_tile_cost(tile, reach_cost)

    var neighbour
    var neighbour_cost

    if not tile.can_acommodate_unit(unit):
        self._scout_tile(tile, unit.side, unit.team)

    if not tile.can_pass_through(unit):
        return

    if depth < 1:
        return

    for key in tile.neighbours.keys():
        neighbour = tile.get_neighbour(key)

        neighbour_cost = self.get_tile_cost(neighbour)

        if neighbour_cost == null || neighbour_cost > reach_cost + 1:
            self.expand_from_tile(neighbour, depth - 1, reach_cost + 1, unit)
            self.connect_path(tile, neighbour)

func connect_path(source_tile, destination_tile):
    var source_key = self._get_key(source_tile)
    var destination_key = self._get_key(destination_tile)

    self.tile_path[destination_key] = source_key

func add_path_root(root_tile):
    self.tile_path[self._get_key(root_tile)] = null

func _get_key(tile):
    return str(tile.position.x) + "_" + str(tile.position.y)

func is_tile_reachable(destination_tile):
    var key = self._get_key(destination_tile)
    return self.tile_path.has(key)

func get_path_to_tile(destination_tile):
    var path = []
    var key = self._get_key(destination_tile)

    while key != null:
        path.append(key)
        key = self.tile_path[key]

    return path

func _scout_tile(tile, side, team):
    var key = self._get_key(tile)
    if tile.has_enemy_unit(side, team):
        if not self.enemy_units.has(key):
            self.enemy_units[key] = tile
    elif tile.has_friendly_unit(side):
        if not self.own_units.has(key):
            self.own_units[key] = tile
    elif tile.has_enemy_building(side, team):
        if not self.enemy_buildings.has(key):
            self.enemy_buildings[key] = tile
    elif tile.has_friendly_building(side):
        if not self.own_buildings.has(key):
            self.own_buildings[key] = tile
    elif tile.has_allied_unit(team):
        if not self.allied_units.has(key):
            self.allied_units[key] = tile
    elif tile.has_allied_building(team):
        if not self.allied_buildings.has(key):
            self.allied_buildings[key] = tile
