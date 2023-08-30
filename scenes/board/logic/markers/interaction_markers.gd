extends Node3D

@export var map: NodePath = null;

var attack_marker_template = preload("res://scenes/ui/markers/attack_marker.tscn")
var capture_marker_template = preload("res://scenes/ui/markers/capture_marker.tscn")

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

func show_interaction_markers_for_tile(tile, ap_limit):
    self.reset()
    if not tile.unit.is_present() || ap_limit < 1:
        return

    var unit = tile.unit.tile
    var neighbour
    for key in tile.neighbours.keys():
        neighbour = tile.get_neighbour(key)

        if self.should_place_attack_marker(neighbour, unit):
            self.mark_tile_for_attack(neighbour)

        if self.should_place_catpure_marker(neighbour, unit):
            self.mark_tile_for_capture(neighbour)

func should_place_catpure_marker(tile, unit):
    if not tile.has_enemy_building(unit.side, unit.team):
        return false

    if unit.move < 1:
        return false

    if not unit.can_capture:
        return false

    return true

func mark_tile_for_capture(tile):
    self.place_marker(self.capture_marker_template.instantiate(), tile)


func should_place_attack_marker(tile, unit):
    if not tile.has_enemy_unit(unit.side, unit.team):
        return false

    if unit.move < 1 || not unit.has_attacks():
        return false

    if not unit.can_attack(tile.unit.tile):
        return false

    return true


func mark_tile_for_attack(tile):
    self.place_marker(self.attack_marker_template.instantiate(), tile)


func place_marker(new_marker, tile):
    self.add_child(new_marker)
    var placement = self.map.map_to_local(tile.position)
    new_marker.set_position(placement)

    self.created_markers[str(tile.position.x) + "_" + str(tile.position.y)] = new_marker
