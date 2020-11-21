
const EAST = "e"
const WEST = "w"
const NORTH = "n"
const SOUTH = "s"

var position = Vector2(0, 0)

var ground = preload("res://scenes/map/tile_fragment.gd").new()
var frame = preload("res://scenes/map/tile_fragment.gd").new()
var decoration = preload("res://scenes/map/tile_fragment.gd").new()
var terrain = preload("res://scenes/map/tile_fragment.gd").new()
var building = preload("res://scenes/map/tile_fragment.gd").new()
var unit = preload("res://scenes/map/tile_fragment.gd").new()

var fragments = []

var neighbours = {}

func _init(x, y):
    self.position.x = x
    self.position.y = y

    self.fragments  = [
        self.ground,
        self.frame,
        self.decoration,
        self.terrain,
        self.building,
        self.unit,
    ]

func has_content():
    for fragment in self.fragments:
        if fragment.is_present():
            return true
    return false

func get_dict():
    return {
        "ground" : self.ground.get_dict(),
        "frame" : self.frame.get_dict(),
        "decoration" : self.decoration.get_dict(),
        "terrain" : self.terrain.get_dict(),
        "building" : self.building.get_dict(),
        "unit" : self.unit.get_dict(),
    }

func wipe():
    self.unit.clear()
    self.building.clear()
    self.terrain.clear()
    self.decoration.clear()
    self.frame.clear()
    self.ground.clear()

func is_selectable(side):
    if self.unit.is_present():
        return self.unit.tile.side == side
    elif self.building.is_present():
        return self.building.tile.side == side

    return false

func add_neighbour(direction, tile):
    self.neighbours[direction] = tile

func get_neighbour(direction):
    if self.neighbours.has(direction):
        return self.neighbours[direction]

    return null


func can_acommodate_unit():
    if not self.ground.is_present():
        return false
    if self.terrain.is_present():
        return false
    if self.building.is_present():
        return false
    if self.unit.is_present():
        return false

    return true

func can_pass_through(side):
    if not self.ground.is_present():
        return false
    if self.terrain.is_present():
        return false
    if self.building.is_present():
        return false
    if self.has_enemy_unit(side):
        return false

    return true

func has_enemy_unit(side):
    if self.unit.is_present() && self.unit.tile.side != side:
        return true
    return false

func has_enemy_building(side):
    if self.building.is_present() && self.building.tile.side != side:
        return true
    return false

func neighbours_enemy_unit(side):
    for direction in self.neighbours.keys():
        if self.neighbours[direction].has_enemy_unit(side):
            return true
    return false

func neighbours_enemy_building(side):
    for direction in self.neighbours.keys():
        if self.neighbours[direction].has_enemy_building(side):
            return true
    return false

func get_direction_to_neighbour(tile):
    for direction in self.neighbours.keys():
        if self.neighbours[direction] == tile:
            return direction
    return null
