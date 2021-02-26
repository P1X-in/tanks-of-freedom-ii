extends Spatial

const RETALIATION_DELAY = 0.1

onready var map = $"map"
onready var ui = $"ui"

onready var audio = $"/root/SimpleAudioLibrary"

var state = preload("res://scenes/board/logic/state.gd").new()
var radial_abilities = preload("res://scenes/board/logic/radial_abilities.gd").new()
var abilities = preload("res://scenes/abilities/abilities.gd").new(self)
var events = preload("res://scenes/board/logic/events.gd").new()
var scripting = preload("res://scenes/board/logic/scripting.gd").new()


var selected_tile = null
var active_ability = null
var last_hover_tile = null
onready var selected_tile_marker = $"marker_anchor/tile_marker"
onready var movement_markers = $"marker_anchor/movement_markers"
onready var interaction_markers = $"marker_anchor/interaction_markers"
onready var path_markers = $"marker_anchor/path_markers"
onready var ability_markers = $"marker_anchor/ability_markers"

onready var explosion = $"marker_anchor/explosion"

func _ready():
    self.load_map("devmap")
    self.set_up_board()
    self.setup_radial_menu()

    self.state.add_player(self.state.PLAYER_HUMAN, self.map.templates.PLAYER_BLUE)
    self.state.add_player(self.state.PLAYER_HUMAN, self.map.templates.PLAYER_RED)
    self.state.add_player_ap(0, 100)
    self.state.add_player_ap(1, 50)

    self.start_turn()

func _input(event):
    if not self.ui.is_panel_open():
        if event.is_action_pressed("ui_accept"):
            self.select_tile(self.map.camera_tile_position)

        if event.is_action_pressed("ui_cancel"):
            self.unselect_action()

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

        self.update_tile_highlight(tile)

        self.path_markers.reset()
        if self.should_draw_move_path(tile):
            var path = self.movement_markers.get_path_to_tile(tile)
            self.path_markers.draw_path(path)
            


func set_up_board():
    self.audio.track("soundtrack_1")
    self.scripting.ingest_scripts(self, self.map.model.scripts)


func end_turn():
    self.toggle_radial_menu()
    self.unselect_tile()
    self.remove_unit_hightlights()
    self.state.switch_to_next_player()
    self.start_turn()

func start_turn():
    self.update_for_current_player()
    self.replenish_unit_actions()
    self.gain_building_ap()
    self.ui.update_resource_value(self.state.get_current_ap())


func select_tile(position):
    var tile = self.map.model.get_tile(position)
    var current_player = self.state.get_current_player()

    if tile.is_selectable(current_player["side"]):
        self.selected_tile = tile
        self.show_contextual_select()

    elif self.selected_tile != null:
        if self.selected_tile.unit.is_present():
            if self.can_move_to_tile(tile):
                self.move_unit(self.selected_tile, tile)
                self.selected_tile = tile
                self.show_contextual_select()
                
            elif self.selected_tile.is_neighbour(tile) && tile.can_unit_interact(self.selected_tile.unit.tile) && self.state.can_current_player_afford(1):
                self.handle_interaction(tile)

            else:
                self.unselect_tile()
                

        elif self.selected_tile.building.is_present():
            if self.active_ability != null && self.ability_markers.marker_exists(position):
                self.execute_active_ability(tile)

            else:
                self.unselect_tile()
                
                
        else:
            self.unselect_tile()

    self.update_tile_highlight(tile)

    if self.selected_tile != null:
        self.audio.play("menu_click")


func unselect_action():
    if self.active_ability != null:
        self.cancel_ability()
    else:
        self.unselect_tile()
    

func unselect_tile():
    self.movement_markers.reset()
    self.interaction_markers.reset()
    self.path_markers.reset()
    self.cancel_ability()
    self.selected_tile = null
    self.selected_tile_marker.hide()

func cancel_ability():
    self.active_ability = null
    self.ability_markers.reset()


func load_map(map_name):
    self.map.loader.load_map_file(map_name)


func update_for_current_player():
    var current_player = self.state.get_current_player()

    self.map.set_tile_box_side(current_player["side"])

func toggle_radial_menu(context_object=null):
    if self.radial_abilities.is_object_without_abilities(self, context_object):
        return

    if not self.ui.is_radial_open():
        self.setup_radial_menu(context_object)
    else:
        self.map.camera.force_stick_reset()

    self.ui.toggle_radial()
    self.map.camera.paused = not self.map.camera.paused
    self.map.tile_box.set_visible(not self.map.tile_box.is_visible())

func setup_radial_menu(context_object=null):
    self.ui.radial.clear_fields()
    if context_object == null:
        self.ui.radial.set_field(self.ui.icons.disk.instance(), "Save/Load game", 2)
        self.ui.radial.set_field(self.ui.icons.back.instance(), "Main menu", 6, get_tree(), "quit")
        self.ui.radial.set_field(self.ui.icons.tick.instance(), "End Turn", 0, self, "end_turn")
    else:
        self.radial_abilities.fill_radial_with_abilities(self, self.ui.radial, context_object)
        

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
    if self.selected_tile.building.is_present():
        self.toggle_radial_menu(self.selected_tile.building.tile)

func move_unit(source_tile, destination_tile):
    var move_cost = self.movement_markers.get_tile_cost(destination_tile)
    destination_tile.unit.set_tile(source_tile.unit.tile)
    source_tile.unit.release()
    self.use_current_player_ap(move_cost)
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
                self.use_current_player_ap(1)
                if self.selected_tile != null && self.selected_tile.unit.is_present():
                    self.show_contextual_select()
            if tile.building.is_present():
                self.capture(self.selected_tile, tile)
                self.use_current_player_ap(1)
                if self.selected_tile != null && self.selected_tile.unit.is_present():
                    self.show_contextual_select()



func battle(attacker_tile, defender_tile):
    var attacker = attacker_tile.unit.tile
    var defender = defender_tile.unit.tile

    attacker.use_move(1)
    attacker.use_attack()

    attacker.rotate_unit_to_direction(attacker_tile.get_direction_to_neighbour(defender_tile))

    defender.receive_damage(attacker.get_attack())
    attacker.sfx_effect("attack")

    if defender.is_alive():
        defender.show_explosion()
        defender.sfx_effect("damage")

        if defender.can_attack(attacker) && defender.has_moves() && defender.has_attacks():
            defender.use_attack()
            attacker.receive_damage(defender.get_attack())

            if attacker.is_alive():
                yield(self.get_tree().create_timer(self.RETALIATION_DELAY), "timeout")
                defender.rotate_unit_to_direction(defender_tile.get_direction_to_neighbour(attacker_tile))
                defender.sfx_effect("attack")
                attacker.show_explosion()
                attacker.sfx_effect("damage")
            else:
                self.unselect_tile()
                self.destroy_unit_on_tile(attacker_tile)
    else:
        self.destroy_unit_on_tile(defender_tile)

func destroy_unit_on_tile(tile):
    var position = tile.unit.tile.get_translation()
    self.explosion.set_translation(Vector3(position.x, 0, position.z))
    self.explosion.explode()
    self.explosion.grab_sfx_effect(tile.unit.tile)
    tile.unit.clear()

func smoke_a_tile(tile):
    var position = self.map.map_to_world(tile.position)
    self.explosion.set_translation(Vector3(position.x, 0, position.z))
    self.explosion.puff_some_smoke()


func capture(attacker_tile, building_tile):
    var attacker = attacker_tile.unit.tile
    var building = building_tile.building.tile

    var event = self.events.get_new_event(self.events.types.BUILDING_CAPTURED)
    event.building = building
    event.old_side = building.side
    event.new_side = attacker.side

    attacker.use_all_moves()
    self.map.builder.set_building_side(building_tile.position, attacker.side)
    self.smoke_a_tile(building_tile)
    building.sfx_effect("capture")

    if building.require_crew:
        yield(self.get_tree().create_timer(self.RETALIATION_DELAY), "timeout")
        self.smoke_a_tile(attacker_tile)
        attacker_tile.unit.clear()
        self.unselect_tile()

    self.events.emit_event(event)

func activate_production_ability(args):
    self.toggle_radial_menu()

    var ability = args[0]

    if self.state.can_current_player_afford(ability.ap_cost):
        self.active_ability = ability
        self.ability_markers.show_ability_markers_for_tile(ability, self.selected_tile)


func execute_active_ability(tile):
    self.abilities.execute_ability(self.active_ability, tile)
    self.cancel_ability()


func remove_unit_hightlights():
    var current_player = self.state.get_current_player()
    var units = self.map.model.get_player_units(current_player["side"])

    for unit in units:
        unit.remove_highlight()

func replenish_unit_actions():
    var current_player = self.state.get_current_player()
    var units = self.map.model.get_player_units(current_player["side"])

    for unit in units:
        unit.replenish_moves()

func gain_building_ap():
    var ap_sum = 0
    var current_player = self.state.get_current_player()
    var buildings = self.map.model.get_player_buildings(current_player["side"])

    for building in buildings:
        ap_sum += building.ap_gain
        if building.ap_gain > 0:
            building.animate_coin()
    
    self.add_current_player_ap(ap_sum)

func add_current_player_ap(ap_sum):
    self.state.add_current_player_ap(ap_sum)
    self.ui.update_resource_value(self.state.get_current_ap())

func use_current_player_ap(value):
    self.state.use_current_player_ap(value)
    self.ui.update_resource_value(self.state.get_current_ap())


func update_tile_highlight(tile):
    if not tile.building.is_present() and not tile.unit.is_present():
        self.ui.clear_tile_highlight()
        return

    var template_name
    var new_side
    var material_type = self.map.templates.MATERIAL_NORMAL

    if tile.building.is_present():
        template_name = tile.building.tile.template_name
        new_side = tile.building.tile.side
    if tile.unit.is_present():
        if tile.unit.tile.uses_metallic_material:
            material_type = self.map.templates.MATERIAL_METALLIC
        template_name = tile.unit.tile.template_name
        new_side = tile.unit.tile.side

    var new_tile = self.map.templates.get_template(template_name)
    new_tile.set_side_material(self.map.templates.get_side_material(new_side, material_type))

    self.ui.update_tile_highlight(new_tile)

    if tile.building.is_present():
        self.ui.update_tile_highlight_building_panel(tile.building.tile)
    if tile.unit.is_present():
        self.ui.update_tile_highlight_unit_panel(tile.unit.tile)

func end_game(winner):
    print("game ended, winner: " + winner)
