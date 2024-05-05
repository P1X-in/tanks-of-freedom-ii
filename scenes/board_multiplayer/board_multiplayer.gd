extends "res://scenes/board/board.gd"



@onready var ui_multiplayer = $"ui_multiplayer"

var all_players_loaded = false
var lock_multicall = 0
var match_ended = false

func _ready():
	super._ready()
	Multiplayer.player_connected.connect(_on_player_connected)
	Multiplayer.player_disconnected.connect(_on_player_disconnected)
	Multiplayer.server_disconnected.connect(_on_server_disconnected)
	Multiplayer.all_players_loaded.connect(_all_players_loaded)

	Multiplayer.player_loaded.rpc_id(1)

func _all_players_loaded():
	_start_game.rpc()

@rpc("call_local", "reliable")
func _start_game():
	self.all_players_loaded = true
	Multiplayer.match_in_progress = true
	_manage_cinematic_bars()
	_manage_ai_start()


func _on_player_connected(peer_id, _player_info):
	self.state.assign_free_peer(peer_id)
	var current_state = SavesManager.compile_save_data(self)["save_data"]
	Multiplayer._set_match_state.rpc_id(peer_id, current_state)

func _on_player_disconnected(peer_id):
	if self.match_ended:
		return

	self.all_players_loaded = false
	self.state.clear_peer_id(peer_id)
	_manage_cinematic_bars()
	_manage_ai_start()
	self.ui_multiplayer.set_announcement(tr("TR_WAITING_FOR_PLAYER_RECONNECTED"))

func _on_server_disconnected():
	if not self.match_ended:
		self.main_menu()

# function overrides
# disable save/load for multiplayer
func perform_autosave():
	return
func cheat_capture():
	return
func cheat_kill():
	return

func _should_perform_hq_cam():
	return false

func restore_saved_state():
	_restore_saved_state(Multiplayer.match_state)
	_notify_player_reconnected.rpc()

func _manage_cinematic_bars():
	if _can_current_player_perform_actions():
		if self.ui.cinematic_bars.is_extended:
			self.ui.hide_cinematic_bars()
			self.ui_multiplayer.clear_announcement()
	else:
		if not self.ui.cinematic_bars.is_extended:
			self.ui.show_cinematic_bars()
			await self.get_tree().create_timer(0.25).timeout
		if self.all_players_loaded:
			if self.state.is_current_player_ai():
				self.ui_multiplayer.set_announcement(tr("TR_AI"))
			else:
				self.ui_multiplayer.set_announcement(Multiplayer.players[self.state.get_current_param("peer_id")]["name"])

func _manage_ai_start():
	if _can_current_player_perform_actions():
		self.map.camera.ai_operated = false
		self.map.show_tile_box()
	else:
		self.map.camera.ai_operated = true
		self.map.hide_tile_box()

		if self.multiplayer.is_server() and self.state.are_all_peers_present() and self.state.is_current_player_ai():
			self.ai.run()

func _can_current_player_perform_actions():
	if multiplayer.multiplayer_peer == null:
		return false

	return self.all_players_loaded and self.state.is_current_player_active_peer(multiplayer.get_unique_id())

func _can_broadcast_moves():
	return _can_current_player_perform_actions() or (self.multiplayer.is_server() and self.state.are_all_peers_present() and self.state.is_current_player_ai())

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
	Multiplayer.close_game()
	super.main_menu()

func _physics_process(_delta):
	super._physics_process(_delta)

	if _can_broadcast_moves():
		_update_camera_position.rpc(self.map.camera.get_position_state())

@rpc("any_peer", "call_remote", "unreliable_ordered")
func _update_camera_position(camera_state):
	self.map.camera.restore_from_state(camera_state)


func select_tile(tile_position):
	self.lock_multicall += 1
	super.select_tile(tile_position)
	self.lock_multicall -= 1

	if _can_broadcast_moves() and self.lock_multicall == 0:
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
	if _can_broadcast_moves():
		_notify_activate_production_ability.rpc(self.selected_tile.position, ability.index)

@rpc("any_peer", "call_remote", "reliable")
func _notify_activate_production_ability(tile_position, ability_index):
	for ability in self.map.model.get_tile(tile_position).building.tile.abilities:
		if ability.index == ability_index:
			_activate_production_ability(ability)
			return

func _activate_ability(ability):
	super._activate_ability(ability)
	if _can_broadcast_moves():
		_notify_activate_ability.rpc(self.selected_tile.position, ability.index)

@rpc("any_peer", "call_remote", "reliable")
func _notify_activate_ability(tile_position, ability_index):
	var unit_tile = self.map.model.get_tile(tile_position)
	for ability in unit_tile.unit.tile.active_abilities:
		if ability.index == ability_index:
			ability.active_source_tile = unit_tile
			_activate_ability(ability)
			return
			
func cancel_ability():
	super.cancel_ability()
	if _can_broadcast_moves() and self.lock_multicall == 0:
		_notify_cancel_ability.rpc()

@rpc("any_peer", "call_remote", "reliable")
func _notify_cancel_ability():
	self.cancel_ability()

func unselect_tile():
	self.lock_multicall += 1
	super.unselect_tile()
	self.lock_multicall -= 1
	if _can_broadcast_moves() and self.lock_multicall == 0:
		_notify_unselect_tile.rpc()

@rpc("any_peer", "call_remote", "reliable")
func _notify_unselect_tile():
	self.unselect_tile()


func _generate_collateral_damage(tile):
	if _can_broadcast_moves():
		var damage = super._generate_collateral_damage(tile)
		_notify_collateral_damage.rpc(damage)

		return damage

@rpc("any_peer", "call_remote", "reliable")
func _notify_collateral_damage(damage):
	if damage["damage"] != null:
		self.collateral.apply_tile_damage(damage["damage"][0], damage["damage"][1], damage["damage"][2])
	for neighbour in damage["collateral"]:
		self.collateral.damage_terrain(self.map.model.get_tile(neighbour))

func _end_turn():
	if _can_broadcast_moves():
		super._end_turn()
		_notify_end_turn.rpc()
	else:
		super._end_turn()

@rpc("any_peer", "call_remote", "reliable")
func _notify_end_turn():
	_end_turn()

func end_game(winner):
	super.end_game(winner)
	self.ui.summary.disable_restart()
	self.match_ended = true


@rpc("any_peer", "call_local", "reliable")
func _notify_player_reconnected():
	self.all_players_loaded = self.state.are_all_peers_present()
	_manage_cinematic_bars()
	_manage_ai_start()
