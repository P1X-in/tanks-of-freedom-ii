extends Spatial

export(NodePath) var map = null;

var marker_template = preload("res://scenes/ui/markers/movement_marker.tscn")
var colour_materials = {
    "green" : ResourceLoader.load("res://assets/materials/arne32_green.tres"),
}

var created_markers = {}

func _ready():
    self.map = self.get_node(self.map)
    
func reset():
    self.destroy_markers()

func destroy_markers():
    var marker
    for key in self.created_markers.keys():
        marker = self.created_markers[key]
        marker.hide()
        marker.queue_free()
    self.created_markers = {}

func show_ability_markers_for_tile(ability, tile):
    if ability.TYPE == "production":
        self.show_production_markers_for_tile(tile)
    
func show_production_markers_for_tile(tile):
    var neighbour
    for direction in tile.neighbours.keys():
        neighbour = tile.neighbours[direction]
        if neighbour.can_acommodate_unit():
            self.place_production_marker(neighbour.position)

func marker_exists(position):
    return self.created_markers.has(str(position.x) + "_" + str(position.y))

func place_production_marker(position):
    var new_marker = self.marker_template.instance()
    self.add_child(new_marker)
    var placement = self.map.map_to_world(position)
    new_marker.set_translation(placement)

    self.created_markers[str(position.x) + "_" + str(position.y)] = new_marker
    new_marker.set_material(self.colour_materials["green"])
