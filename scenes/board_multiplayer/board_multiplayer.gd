extends "res://scenes/board/board.gd"

@onready var multiplayer_srv = $"/root/Multiplayer"

var all_players_loaded = false
var lock_multicall = 0

func _ready():
	super._ready()
	self.multiplayer_srv.player_connected.connect(_on_player_connected)
	self.multiplayer_srv.player_disconnected.connect(_on_player_disconnected)
	self.multiplayer_srv.server_disconnected.connect(_on_server_disconnected)
	self.multiplayer_srv.all_players_loaded.connect(_all_players_loaded)

	self.multiplayer_srv.player_loaded.rpc_id(1)

func _all_players_loaded():
	_start_game.rpc()

@rpc("call_local", "reliable")
func _start_game():
	self.all_players_loaded = true
	_manage_cinematic_bars()
	_manage_ai_start()


func _on_player_connected(_peer_id, _player_info):
	return

func _on_player_disconnected(_peer_id):
	return

func _on_server_disconnected():
	self.main_menu()

# function overrides
# disable save/load for multiplayer
func perform_autosave():
	return
func restore_saved_state():
	return

func _should_perform_hq_cam():
	return false

func _manage_cinematic_bars():
	if _can_current_player_perform_actions():
		if self.ui.cinematic_bars.is_extended:
			self.ui.hide_cinematic_bars()
	else:
		if not self.ui.cinematic_bars.is_extended:
			self.ui.show_cinematic_bars()
			await self.get_tree().create_timer(0.25).timeout

func _manage_ai_start():
	if _can_current_player_perform_actions():
		self.map.camera.ai_operated = false
		self.map.show_tile_box()
	else:
		self.map.camera.ai_operated = true
		self.map.hide_tile_box()

func _can_current_player_perform_actions():
	return self.all_players_loaded and self.state.is_current_player_active_peer(multiplayer.get_unique_id())

func setup_radial_menu(context_object=null):
	if context_object != null and not _can_current_player_perform_actions():
		return

	super.setup_radial_menu(context_object)

	if context_object == null:
		self.ui.radial.set_field_disabled(0, "X")
		self.ui.radial.set_field_disabled(2, "X")

func _show_contextual_select_radial(open_unit_abilities):
	if _can_current_player_perform_actions():
		super._show_contextual_select_radial(open_unit_abilities)

func _add_player_to_state(data):
	self.state.add_player(data["type"], data["side"], data["alive"], data["team"], data["peer_id"])

func main_menu():
	self.multiplayer_srv.close_game()
	super.main_menu()

func _physics_process(_delta):
	super._physics_process(_delta)

	if _can_current_player_perform_actions():
		_update_camera_position.rpc(self.map.camera.get_position_state())

@rpc("any_peer", "call_remote", "unreliable_ordered")
func _update_camera_position(camera_state):
	self.map.camera.restore_from_state(camera_state)


func select_tile(tile_position):
	self.lock_multicall += 1
	super.select_tile(tile_position)
	self.lock_multicall -= 1

	if _can_current_player_perform_actions() and self.lock_multicall == 0:
		_update_tile_select.rpc(tile_position)

func _reselect_tile(tile_position):
	self.lock_multicall += 1
	super.select_tile(tile_position)
	self.lock_multicall -= 1


@rpc("any_peer", "call_remote", "reliable")
func _update_tile_select(tile_position):
	select_tile(tile_position)


func _activate_production_ability(ability):
	super._activate_production_ability(ability)
	if _can_current_player_perform_actions():
		_notify_activate_production_ability.rpc(self.selected_tile.position, ability.index)

@rpc("any_peer", "call_remote", "reliable")
func _notify_activate_production_ability(tile_position, ability_index):
	for ability in self.map.model.get_tile(tile_position).building.tile.abilities:
		if ability.index == ability_index:
			_activate_production_ability(ability)
			return

func _activate_ability(ability):
	super._activate_ability(ability)
	if _can_current_player_perform_actions():
		_notify_activate_ability.rpc(self.selected_tile.position, ability.index)

@rpc("any_peer", "call_remote", "reliable")
func _notify_activate_ability(tile_position, ability_index):
	for ability in self.map.model.get_tile(tile_position).unit.tile.active_abilities:
		if ability.index == ability_index:
			_activate_ability(ability)
			return
			
func cancel_ability():
	super.cancel_ability()
	if _can_current_player_perform_actions() and self.lock_multicall == 0:
		_notify_cancel_ability.rpc()

@rpc("any_peer", "call_remote", "reliable")
func _notify_cancel_ability():
	self.cancel_ability()

func unselect_tile():
	self.lock_multicall += 1
	super.unselect_tile()
	self.lock_multicall -= 1
	if _can_current_player_perform_actions() and self.lock_multicall == 0:
		_notify_unselect_tile.rpc()

@rpc("any_peer", "call_remote", "reliable")
func _notify_unselect_tile():
	self.unselect_tile()
	
