extends "res://scenes/board/board.gd"

@onready var relay = $"/root/Relay"

@onready var ui_multiplayer = $"ui_multiplayer"

var all_players_loaded = false
var lock_multicall = 0
var match_ended = false

var _last_camera_state = null


func _ready():
	super._ready()
	self.relay.player_connected.connect(_on_player_connected)
	self.relay.player_disconnected.connect(_on_player_disconnected)
	self.relay.server_disconnected.connect(_on_server_disconnected)
	self.relay.all_players_loaded.connect(_all_players_loaded)
	self.relay.message_received.connect(_on_message_incoming)

	self.relay.player_loaded()


func _ready_start():
	pass


func _on_message_incoming(message):
	if self.match_ended:
		return

	if message["action"] == "message":
		_handle_message(message["payload"])


func _handle_message(message):
	if message["type"] == "player_loaded":
		self.relay.mark_player_loaded()
	if message["type"] == "game_start":
		self._start_game()
	if message["type"] == "player_reconnected":
		self._notify_player_reconnected()
	if message["type"] == "camera_position":
		self._update_camera_position(message["position"])
	if message["type"] == "tile_select":
		self._update_tile_select(Vector2(int(message["x"]), int(message["y"])))
	if message["type"] == "activate_production_ability":
		self._notify_activate_production_ability(Vector2(int(message["x"]), int(message["y"])), int(message["index"]))
	if message["type"] == "activate_ability":
		self._notify_activate_ability(Vector2(int(message["x"]), int(message["y"])), int(message["index"]))
	if message["type"] == "cancel_ability":
		self._notify_cancel_ability()
	if message["type"] == "unselect_tile":
		self._notify_unselect_tile()
	if message["type"] == "collateral_damage":
		self._notify_collateral_damage(message["damage"])
	if message["type"] == "end_turn":
		self._notify_end_turn()


func _all_players_loaded():
	if self.match_ended:
		return

	self.relay.message_broadcast({
		"type": "game_start"
	})
	_start_game()


#@rpc("call_local", "reliable")
func _start_game():
	self.all_players_loaded = true
	self.relay.match_in_progress = true
	_manage_cinematic_bars()
	start_turn()


func _on_player_connected(peer_id, _player_info):
	if self.match_ended:
		return

	self.state.assign_free_peer(peer_id)
	if self.relay.is_server():
		var current_state = self.saves_manager.compile_save_data(self)["save_data"]
		self.relay.message_direct(peer_id, {
			"type": "match_state",
			"state": current_state
		})
	#self.multiplayer_srv._set_match_state.rpc_id(peer_id, current_state)


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
	_restore_saved_state(self.relay.match_state)
	self.relay.message_broadcast({
		"type": "player_reconnected"
	})
	self._notify_player_reconnected()
	#_notify_player_reconnected.rpc()


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
				print(self.relay.players)
				self.ui_multiplayer.set_announcement(self.relay.players[self.state.get_current_param("peer_id")]["name"])


func _manage_ai_start():
	if _can_current_player_perform_actions():
		self.map.camera.ai_operated = false
		self.map.show_tile_box()
	else:
		self.map.camera.ai_operated = true
		self.map.hide_tile_box()

		if self.relay.is_server() and self.state.are_all_peers_present() and self.state.is_current_player_ai():
			self.ai.run()


func _can_current_player_perform_actions():
	if self.relay.peer_id == 0:
		return false

	return self.all_players_loaded and self.state.is_current_player_active_peer(self.relay.peer_id)


func _can_broadcast_moves():
	return _can_current_player_perform_actions() or (self.relay.is_server() and self.state.are_all_peers_present() and self.state.is_current_player_ai())


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
	self.match_ended = true
	self.relay.close_game()
	super.main_menu()


func _physics_process(_delta):
	if self.match_ended:
		return

	super._physics_process(_delta)

	if _can_broadcast_moves():
		var new_camera_state = self.map.camera.get_position_state()
		if self._last_camera_state != new_camera_state:
			self.relay.message_broadcast({
				"type": "camera_position",
				"position": new_camera_state
			})
			self._last_camera_state = new_camera_state
		#_update_camera_position.rpc(self.map.camera.get_position_state())


#@rpc("any_peer", "call_remote", "unreliable_ordered")
func _update_camera_position(camera_state):
	self.map.camera.restore_from_state(camera_state)


func select_tile(tile_position):
	self.lock_multicall += 1
	super.select_tile(tile_position)
	self.lock_multicall -= 1

	if _can_broadcast_moves() and self.lock_multicall == 0:
		self.relay.message_broadcast({
			"type": "tile_select",
			"x": tile_position.x,
			"y": tile_position.y,
		})
		#_update_tile_select.rpc(tile_position)


func _reselect_tile(tile_position):
	self.lock_multicall += 1
	super.select_tile(tile_position)
	self.lock_multicall -= 1


#@rpc("any_peer", "call_remote", "reliable")
func _update_tile_select(tile_position):
	select_tile(tile_position)


func _activate_production_ability(ability):
	super._activate_production_ability(ability)
	if _can_broadcast_moves():
		self.relay.message_broadcast({
			"type": "activate_production_ability",
			"x": self.selected_tile.position.x,
			"y": self.selected_tile.position.y,
			"index": ability.index
		})
		#_notify_activate_production_ability.rpc(self.selected_tile.position, ability.index)


#@rpc("any_peer", "call_remote", "reliable")
func _notify_activate_production_ability(tile_position, ability_index):
	for ability in self.map.model.get_tile(tile_position).building.tile.abilities:
		if ability.index == ability_index:
			_activate_production_ability(ability)
			return


func _activate_ability(ability):
	super._activate_ability(ability)
	if _can_broadcast_moves():
		self.relay.message_broadcast({
			"type": "activate_ability",
			"x": self.selected_tile.position.x,
			"y": self.selected_tile.position.y,
			"index": ability.index
		})
		#_notify_activate_ability.rpc(self.selected_tile.position, ability.index)


#@rpc("any_peer", "call_remote", "reliable")
func _notify_activate_ability(tile_position, ability_index):
	var unit_tile = self.map.model.get_tile(tile_position)
	for ability in unit_tile.unit.tile.active_abilities:
		if ability.index == ability_index:
			ability.active_source_tile = unit_tile
			_activate_ability(ability)
			return


func cancel_ability():
	self.lock_multicall += 1
	super.cancel_ability()
	self.lock_multicall -= 1
	if _can_broadcast_moves() and self.lock_multicall == 0:
		self.relay.message_broadcast({
			"type": "cancel_ability"
		})
		#_notify_cancel_ability.rpc()


#@rpc("any_peer", "call_remote", "reliable")
func _notify_cancel_ability():
	self.cancel_ability()


func unselect_tile():
	self.lock_multicall += 1
	super.unselect_tile()
	self.lock_multicall -= 1
	if _can_broadcast_moves() and self.lock_multicall == 0:
		self.relay.message_broadcast({
			"type": "unselect_tile"
		})
		#_notify_unselect_tile.rpc()


#@rpc("any_peer", "call_remote", "reliable")
func _notify_unselect_tile():
	self.unselect_tile()


func _generate_collateral_damage(tile):
	if _can_broadcast_moves():
		var damage = super._generate_collateral_damage(tile)
		var fixed_damage = {
			"collateral": [],
			"damage": null
		}

		for damaged_tile in damage["collateral"]:
			fixed_damage["collateral"].append([damaged_tile.x, damaged_tile.y])
		if damage["damage"] != null:
			fixed_damage["damage"] = [
				[damage["damage"][0].x, damage["damage"][0].y],
				damage["damage"][1],
				damage["damage"][2]
			]

		self.relay.message_broadcast({
			"type": "collateral_damage",
			"damage": fixed_damage
		})
		#_notify_collateral_damage.rpc(damage)

		return damage


#@rpc("any_peer", "call_remote", "reliable")
func _notify_collateral_damage(damage):
	if damage["damage"] != null:
		self.collateral.apply_tile_damage(Vector2(int(damage["damage"][0][0]), int(damage["damage"][0][1])), damage["damage"][1], damage["damage"][2])
	for neighbour in damage["collateral"]:
		self.collateral.damage_terrain(self.map.model.get_tile(Vector2(int(neighbour[0]), int(neighbour[1]))))


func end_turn():
	if self.ui.radial.is_visible():
		self.toggle_radial_menu()
	_end_turn()


func _end_turn():
	if _can_broadcast_moves():
		super._end_turn()
		self.relay.message_broadcast({
			"type": "end_turn"
		})
		#_notify_end_turn.rpc()
	else:
		super._end_turn()


#@rpc("any_peer", "call_remote", "reliable")
func _notify_end_turn():
	_end_turn()


func end_game(winner):
	super.end_game(winner)
	self.ui.summary.disable_restart()
	self.match_ended = true
	self.relay.close_game()


#@rpc("any_peer", "call_local", "reliable")
func _notify_player_reconnected():
	self.all_players_loaded = self.state.are_all_peers_present()
	self.relay.players_loaded = 0
	_manage_cinematic_bars()
	_manage_ai_start()
