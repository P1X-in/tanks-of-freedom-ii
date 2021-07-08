extends Spatial

export(NodePath) var map = null;

var marker_template = preload("res://scenes/ui/markers/movement_marker.tscn")
var colour_materials = {
    "blue" : ResourceLoader.load("res://assets/materials/arne32_blue.tres"),
    "red" : ResourceLoader.load("res://assets/materials/arne32_red.tres"),
    "green" : ResourceLoader.load("res://assets/materials/arne32_green.tres"),
    "yellow" : ResourceLoader.load("res://assets/materials/arne32_yellow.tres"),
    "neutral" : ResourceLoader.load("res://assets/materials/arne32_neutral.tres"),
}

var created_markers = {}
var tiles_in_range = {}

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

func show_ability_markers_for_tile(ability, tile):
    self.destroy_markers()
    if ability.TYPE == "production":
        self.show_production_markers_for_tile(tile)
    if ability.TYPE == "hero_active":
        self.show_hero_markers_for_tile(tile, ability)
    
func show_production_markers_for_tile(tile):
    var neighbour
    for direction in tile.neighbours.keys():
        neighbour = tile.neighbours[direction]
        if neighbour.can_acommodate_unit():
            self.place_marker(neighbour.position)

func show_hero_markers_for_tile(tile, ability):
    self.tiles_in_range.clear()
    self.tiles_in_range[self._get_key(tile)] = tile

    self.expand_from_tile(tile, ability.ability_range)

    for tile in self.tiles_in_range.values():
        if ability.is_tile_applicable(tile):
            self.place_marker(tile.position, ability.marker_colour)

func expand_from_tile(tile, depth):
    if depth < 1:
        return

    var key

    for neighbour in tile.neighbours.values():
        key = self._get_key(neighbour)

        if not self.tiles_in_range.has(key):
            self.tiles_in_range[key] = neighbour
            self.expand_from_tile(neighbour, depth - 1)

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
