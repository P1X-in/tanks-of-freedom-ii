extends Spatial

export(NodePath) var map = null;

var marker_template = preload("res://scenes/ui/markers/movement_marker.tscn")
var range_template = preload("res://scenes/ui/markers/range_marker.tscn")
var colour_materials = {
    "blue" : ResourceLoader.load("res://assets/materials/arne32_blue.tres"),
    "red" : ResourceLoader.load("res://assets/materials/arne32_red.tres"),
    "green" : ResourceLoader.load("res://assets/materials/arne32_green.tres"),
    "yellow" : ResourceLoader.load("res://assets/materials/arne32_yellow.tres"),
    "neutral" : ResourceLoader.load("res://assets/materials/arne32_neutral.tres"),
}

var created_markers = {}
var extra_markers = []
var tiles_in_range = {}
var explored_tiles_distance = {}

func _ready():
    self.map = self.get_node(self.map)
    
func reset():
    self.tiles_in_range.clear()
    self.destroy_markers()

func destroy_markers():
    var marker
    for key in self.created_markers.keys():
        marker = self.created_markers[key]
        marker.hide()
        marker.queue_free()
    self.created_markers = {}
    for extra_marker in self.extra_markers:
        extra_marker.hide()
        extra_marker.queue_free()
    self.extra_markers = []

func show_ability_markers_for_tile(ability, tile):
    self.destroy_markers()
    if ability.TYPE == "production":
        self.show_production_markers_for_tile(tile)
    if ability.TYPE == "hero_active" or ability.TYPE == "active":
        self.show_hero_markers_for_tile(tile, ability)
    
func show_production_markers_for_tile(tile):
    var neighbour
    for direction in tile.neighbours.keys():
        neighbour = tile.neighbours[direction]
        if neighbour.can_acommodate_unit():
            self.place_marker(neighbour.position)

func get_all_tiles_in_ability_range(ability, tile):
    self.tiles_in_range.clear()
    self.explored_tiles_distance.clear()
    self.tiles_in_range[self._get_key(tile)] = tile
    self.explored_tiles_distance[self._get_key(tile)] = 0

    self.expand_from_tile(tile, ability.ability_range, 0)

    return self.tiles_in_range.values()

func show_hero_markers_for_tile(source_tile, ability):
    self.get_all_tiles_in_ability_range(ability, source_tile)
    self._draw_ability_range(source_tile, ability.draw_range, ability.in_line)

    for tile in self.tiles_in_range.values():
        if ability.is_tile_applicable(tile, source_tile):
            self.place_marker(tile.position, ability.marker_colour)

func expand_from_tile(tile, depth, distance):
    if depth < 1:
        return

    var key
    var neighbour_distance = null


    for neighbour in tile.neighbours.values():
        key = self._get_key(neighbour)
        if self.explored_tiles_distance.has(key):
            neighbour_distance = self.explored_tiles_distance[key]

        if not self.tiles_in_range.has(key) or (neighbour_distance != null and neighbour_distance > distance + 1):
            self.tiles_in_range[key] = neighbour
            self.explored_tiles_distance[key] = distance + 1
            self.expand_from_tile(neighbour, depth - 1, distance + 1)

func marker_exists(position):
    return self.created_markers.has(str(position.x) + "_" + str(position.y))

func place_marker(position, colour="green"):
    var new_marker = self.marker_template.instance()
    self.add_child(new_marker)
    var placement = self.map.map_to_world(position)
    new_marker.set_translation(placement)

    self.created_markers[str(position.x) + "_" + str(position.y)] = new_marker
    new_marker.set_material(self.colour_materials[colour])

func _get_key(tile):
    return str(tile.position.x) + "_" + str(tile.position.y)

func _draw_ability_range(source_tile, ability_range, in_line):
    if ability_range < 1:
        return

    var x
    var y

    for x_index in range(-ability_range, ability_range + 1):
        for y_index in range(-ability_range, ability_range + 1):
            x = source_tile.position.x + x_index
            y = source_tile.position.y + y_index

            if x < 0 or x >= self.map.model.SIZE or y < 0 or y >= self.map.model.SIZE:
                continue

            if not in_line and abs(x_index) + abs(y_index) == ability_range:
                if x_index <= 0:
                    self._place_extra_marker(Vector2(x, y), 90)
                if x_index >= 0:
                    self._place_extra_marker(Vector2(x, y), 270)
                if y_index <= 0:
                    self._place_extra_marker(Vector2(x, y), 0)
                if y_index >= 0:
                    self._place_extra_marker(Vector2(x, y), 180)

            if in_line and (x_index == 0 or y_index == 0) and (x_index + y_index != 0):
                if x_index == 0:
                    self._place_extra_marker(Vector2(x, y), 90)
                    self._place_extra_marker(Vector2(x, y), 270)

                if y_index == 0:
                    self._place_extra_marker(Vector2(x, y), 0)
                    self._place_extra_marker(Vector2(x, y), 180)

                if y_index == -ability_range:
                    self._place_extra_marker(Vector2(x, y), 0)
                if y_index == ability_range:
                    self._place_extra_marker(Vector2(x, y), 180)
                if x_index == -ability_range:
                    self._place_extra_marker(Vector2(x, y), 90)
                if x_index == ability_range:
                    self._place_extra_marker(Vector2(x, y), 270)

func _place_extra_marker(position, rotation):
    var new_marker = self.range_template.instance()
    self.add_child(new_marker)
    var placement = self.map.map_to_world(position)
    new_marker.set_translation(placement)
    new_marker.set_rotation(Vector3(0, deg2rad(rotation), 0))

    self.extra_markers.append(new_marker)
