extends Spatial

const RETALIATION_DELAY = 0.1

onready var map = $"map"
onready var ui = $"ui"

var state = preload("res://scenes/board/state.gd").new()

var selected_tile = null
var last_hover_tile = null
onready var selected_tile_marker = $"marker_anchor/tile_marker"
onready var movement_markers = $"marker_anchor/movement_markers"
onready var interaction_markers = $"marker_anchor/interaction_markers"
onready var path_markers = $"marker_anchor/path_markers"

onready var explosion = $"marker_anchor/explosion"

func _ready():
    self.load_map("devmap")
    self.set_up_board()
    self.setup_radial_menu()

    self.state.add_player(self.state.PLAYER_HUMAN, self.map.templates.PLAYER_BLUE)
    self.state.add_player(self.state.PLAYER_HUMAN, self.map.templates.PLAYER_RED)
    self.state.add_player_ap(0, 50)
    self.state.add_player_ap(1, 50)

    self.update_for_current_player()


func _input(event):
    if not self.ui.is_panel_open():
        if event.is_action_pressed("ui_accept"):
            self.select_tile(self.map.camera_tile_position)

        if event.is_action_pressed("ui_cancel"):
            self.unselect_tile()

        if event.is_action_pressed("editor_menu"):
            self.toggle_radial_menu()
    else:
        if self.ui.radial.is_visible() and not self.ui.is_popup_open():
            if event.is_action_pressed("ui_cancel"):
                self.toggle_radial_menu()

            if event.is_action_pressed("editor_menu"):
                self.toggle_radial_menu()

func _physics_process(_delta):
    self.hover_tile() 

func hover_tile():
    var tile = self.map.model.get_tile(self.map.camera_tile_position)

    if tile != self.last_hover_tile:
        self.last_hover_tile = tile

        self.path_markers.reset()
        if self.should_draw_move_path(tile):
            var path = self.movement_markers.get_path_to_tile(tile)
            self.path_markers.draw_path(path)
            


func set_up_board():
    return


func end_turn():
    return


func select_tile(position):
    var tile = self.map.model.get_tile(position)
    var current_player = self.state.get_current_player()

    if tile.is_selectable(current_player["side"]):
        self.selected_tile = tile
        self.show_contextual_select()
        return

    if self.selected_tile != null:
        if self.selected_tile.unit.is_present():
            if self.can_move_to_tile(tile):
                self.move_unit(self.selected_tile, tile)
                self.selected_tile = tile
                self.show_contextual_select()
                return
            elif self.selected_tile.is_neighbour(tile) && tile.can_unit_interact(self.selected_tile.unit.tile):
                self.handle_interaction(tile)
                return

        self.unselect_tile()

    

func unselect_tile():
    self.movement_markers.reset()
    self.interaction_markers.reset()
    self.path_markers.reset()
    self.selected_tile = null
    self.selected_tile_marker.hide()


func load_map(map_name):
    self.map.loader.load_map_file(map_name)


func update_for_current_player():
    var current_player = self.state.get_current_player()

    self.map.set_tile_box_side(current_player["side"])

func toggle_radial_menu():
    self.ui.toggle_radial()
    self.map.camera.paused = not self.map.camera.paused
    self.map.tile_box.set_visible(not self.map.tile_box.is_visible())

func setup_radial_menu():
    self.ui.radial.set_field(self.ui.icons.disk.instance(), "Save/Load game", 2)
    self.ui.radial.set_field(self.ui.icons.back.instance(), "Main menu", 6, get_tree(), "quit")

func place_selection_marker():
    self.selected_tile_marker.show()
    var new_position = self.selected_tile_marker.get_translation()
    var placement = self.map.map_to_world(self.selected_tile.position)
    placement.y = new_position.y
    self.selected_tile_marker.set_translation(placement)

func show_unit_movement_markers():
    self.movement_markers.show_unit_movement_markers_for_tile(self.selected_tile, self.state.get_current_ap())

func show_unit_interaction_markers():
    self.interaction_markers.show_interaction_markers_for_tile(self.selected_tile, self.state.get_current_ap())

func show_contextual_select():
    self.place_selection_marker()
    self.movement_markers.reset()
    self.path_markers.reset()
    
    if self.selected_tile.unit.is_present():
        self.show_unit_movement_markers()
        self.show_unit_interaction_markers()

func move_unit(source_tile, destination_tile):
    var move_cost = self.movement_markers.get_tile_cost(destination_tile)
    destination_tile.unit.set_tile(source_tile.unit.tile)
    source_tile.unit.release()
    self.state.use_current_player_ap(move_cost)
    destination_tile.unit.tile.use_move(move_cost)

    self.reset_unit_position(source_tile, destination_tile.unit.tile)
    self.update_unit_position(destination_tile)

func update_unit_position(tile):
    var path = self.movement_markers.get_path_to_tile(tile)
    var movement_path = self.path_markers.convert_path_to_directions(path)
    var unit = tile.unit.tile

    unit.animate_path(movement_path)

func reset_unit_position(tile, unit):
    unit.stop_animations()
    var world_position = self.map.map_to_world(tile.position)
    var old_position = unit.get_translation()
    world_position.y = old_position.y
    unit.set_translation(world_position)

func can_move_to_tile(tile):
    var move_cost = self.movement_markers.get_tile_cost(tile)
    if move_cost != null and move_cost > 0 and tile.can_acommodate_unit():
        return true
    return false

func should_draw_move_path(tile):
    if self.selected_tile != null:
        if self.selected_tile.unit.is_present():
            if self.can_move_to_tile(tile):
                return true
    return false

func handle_interaction(tile):
    if self.selected_tile != null:
        if self.selected_tile.unit.is_present():
            if tile.unit.is_present():
                self.battle(self.selected_tile, tile)
                if self.selected_tile != null && self.selected_tile.unit.is_present():
                    self.show_contextual_select()



func battle(attacker_tile, defender_tile):
    var attacker = attacker_tile.unit.tile
    var defender = defender_tile.unit.tile

    attacker.use_move(1)
    attacker.use_attack()

    defender.receive_damage(attacker.get_attack())

    if defender.is_alive():
        defender.show_explosion()

        if defender.can_attack(attacker) && defender.has_moves() && defender.has_attacks():
            defender.use_attack()
            attacker.receive_damage(defender.get_attack())

            if attacker.is_alive():
                yield(self.get_tree().create_timer(self.RETALIATION_DELAY), "timeout")
                attacker.show_explosion()
            else:
                self.unselect_tile()
                self.destroy_unit_on_tile(attacker_tile)
    else:
        self.destroy_unit_on_tile(defender_tile)

func destroy_unit_on_tile(tile):
    var position = tile.unit.tile.get_translation()
    self.explosion.set_translation(Vector3(position.x, 0, position.z))
    self.explosion.explode()
    tile.unit.clear()
