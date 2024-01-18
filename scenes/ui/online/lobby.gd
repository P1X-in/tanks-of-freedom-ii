extends "res://scenes/ui/menu/base_menu_panel.gd"

@onready var relay = $"/root/Relay"
@onready var online = $"/root/Online"
@onready var map_list_service = $"/root/MapManager"
@onready var switcher = $"/root/SceneSwitcher"
@onready var match_setup = $"/root/MatchSetup"
@onready var start_button = $"widgets/start_button"
@onready var back_button = $"widgets/back_button"
@onready var minimap = $"widgets/minimap"

@onready var widgets = $"widgets"
@onready var downloading_label = $"downloading"

@onready var player_panels = [
	$"widgets/lobby_player_0",
	$"widgets/lobby_player_1",
	$"widgets/lobby_player_2",
	$"widgets/lobby_player_3",
]
@onready var player_labels = [
	[$"widgets/player_0", $"widgets/player_0/label"],
	[$"widgets/player_1", $"widgets/player_1/label"],
	[$"widgets/player_2", $"widgets/player_2/label"],
	[$"widgets/player_3", $"widgets/player_3/label"],
]
var hq_templates = [
	"modern_hq",
	"steampunk_hq",
	"futuristic_hq",
	"feudal_hq",
]
var server_state = null

func _ready():
	super._ready()
	self.relay.player_connected.connect(_on_player_connected)
	self.relay.player_disconnected.connect(_on_player_disconnected)
	self.relay.server_disconnected.connect(_on_server_disconnected)

	self.relay.message_received.connect(_on_message_incoming)

	for panel in self.player_panels:
		panel.player_joined.connect(_on_player_joined_side)
		panel.player_left.connect(_on_player_left_side)
		panel.state_changed.connect(_on_panel_state_changed)
		panel.swap_happened.connect(_on_panel_swap)

func show_panel():
	super.show_panel()

	if self.map_list_service._is_bundled(self.relay.selected_map) or self.map_list_service._is_online(self.relay.selected_map):

		_prepare_initial_panel_state(self.relay.selected_map)
	else:
		self._download_map_data(self.relay.selected_map)

func _download_map_data(map_name):
	self.widgets.hide()
	self.downloading_label.show()

	var result = await self.online.download_map(map_name)

	self.downloading_label.hide()
	self.widgets.show()

	if result:
		_prepare_initial_panel_state(map_name)
	else:
		_on_back_button_pressed()


func _prepare_initial_panel_state(map_name):
	if self.relay.match_in_progress:
		self.widgets.hide()
		while not self.relay.match_state_available:
			await self.get_tree().create_timer(0.1).timeout
		self.load_game_from_state(self.relay.match_state)
		return

	self._fill_map_data(map_name)
	_fill_player_labels()
	self._apply_server_state()
	await self.get_tree().create_timer(0.1).timeout
	_manage_start_button(true)


func _manage_start_button(grab):
	if relay.is_server() and _is_ready_to_start():
		self.start_button.show()
		if grab:
			self.start_button.grab_focus()
	else:
		self.start_button.hide()
		if grab:
			self.back_button.grab_focus()

func _is_ready_to_start():
	var player_spots = 0
	var human_players = self.relay.players.size()
	var players_assigned = 0
	var ai_assigned = 0

	for panel in self.player_panels:
		if panel.is_visible():
			player_spots += 1
			if panel.type == "human":
				if panel.player_peer_id != null:
					players_assigned += 1
			else:
				ai_assigned += 1

	if human_players > players_assigned:
		return false

	return players_assigned + ai_assigned == player_spots


func _fill_map_data(fill_name):
	self.minimap.fill_minimap(fill_name)
	$"widgets/minimap/map_name/label".set_text(fill_name)
	self._fill_player_panels(fill_name)

func _fill_player_labels():
	for label in self.player_labels:
		label[0].hide()

	var player_info = self.relay.players.values()
	for index in range(player_info.size()):
		self.player_labels[index][0].show()
		self.player_labels[index][1].set_text(player_info[index]["name"])


func _hide_player_panels():
	for panel in self.player_panels:
		panel.hide()
		panel._reset_labels()

func _fill_player_panels(fill_name):
	self._hide_player_panels()

	var sides = self._gather_player_sides(self.map_list_service.get_map_data(fill_name))

	var index = 0

	for side in sides:
		if index >= self.player_panels.size():
			continue
		self.player_panels[index].fill_panel(side)
		self.player_panels[index].show()
		index += 1

func _gather_player_sides(map_data):
	var sides = {}
	var side
	var key

	for y in range(self.map_list_service.MAX_MAP_SIZE):
		for x in range(self.map_list_service.MAX_MAP_SIZE):
			key = str(x) + "_" + str(y)
			if map_data["tiles"].has(key):
				side = self._lookup_side(map_data["tiles"][key])
				
				if side != null:
					sides[side] = side

	return sides

func _lookup_side(data):
	if data["building"]["tile"] != null:
		if data["building"]["tile"] in self.hq_templates:
			return data["building"]["side"]

	return null

	
func _on_back_button_pressed():
	if self.downloading_label.is_visible():
		return

	super._on_back_button_pressed()
	
	self.relay.close_game()
	self.main_menu.close_online_lobby()

func _on_player_connected(peer_id, _player_info):
	if not self.is_visible():
		return

	_fill_player_labels()
	if relay.is_server() and peer_id != relay.peer_id:
		var state = {}
		for panel in self.player_panels:
			state[panel.index] = {
				"type": panel.type,
				"side": panel.side,
				"peer_id": panel.player_peer_id,
				"ap": panel.ap,
				"team": panel.team
			}
		self.relay.message_direct(peer_id, {
			"type": "state",
			"state": state
		})
		#_set_lobby_state.rpc_id(peer_id, state)
	for panel in self.player_panels:
		panel._update_join_label()

func _on_player_disconnected(peer_id):
	if not self.is_visible():
		return

	_fill_player_labels()
	for panel in self.player_panels:
		if panel.player_peer_id == peer_id:
			panel._set_peer_id(null)
	_manage_start_button(false)

func _on_server_disconnected():
	if not self.is_visible():
		return

	_on_back_button_pressed()


func _on_start_button_pressed():
	self.audio.play("menu_click")
	self.relay.game_start()
	#_load_multiplayer_game.rpc()


func _on_message_incoming(message):
	if message["action"] == "game_start":
		self._load_multiplayer_game()
		return
	if message["action"] == "message":
		_handle_message(message["payload"])

func _handle_message(message):
	if message["type"] == "state":
		self._set_lobby_state(message["state"])
	if message["type"] == "player_joined_side":
		self._player_joined_a_side(int(message["peer_id"]), message["index"])
	if message["type"] == "player_left_side":
		self._player_left_a_side(message["index"])
	if message["type"] == "player_panel_updated":
		self._update_panel_state(message["index"], message["ap"], message["team"], message["ptype"])
	if message["type"] == "player_panel_swap":
		self._swap_panel(message["index"])


#@rpc("call_local", "reliable")
func _load_multiplayer_game():
	self.match_setup.reset()
	self.match_setup.map_name = self.relay.selected_map
	self.match_setup.is_multiplayer = true

	for player in self.player_panels:
		if player.player_peer_id != null or player.type == "ai":
			self.match_setup.add_player(player.side, player.ap, player.type, true, player.team, player.player_peer_id)

	self.switcher.board_online()

func _on_player_joined_side(index):
	for panel in self.player_panels:
		if panel.index != index:
			if relay.is_server():
				panel.switch_to_ai()
			else:
				panel.lock_side()
	self.relay.message_broadcast({
		"type": "player_joined_side",
		"peer_id": self.relay.peer_id,
		"index": index
	})
	#for peer_id in self.multiplayer_srv.players:
	#	if peer_id != relay.peer_id:
	#		_player_joined_a_side.rpc_id(peer_id, multiplayer.get_unique_id(), index)
	_manage_start_button(false)

func _on_player_left_side(index):
	for panel in self.player_panels:
		if panel.index != index:
			panel.unlock_side()
	self.relay.message_broadcast({
		"type": "player_left_side",
		"index": index
	})
	#for peer_id in self.multiplayer_srv.players:
	#	if peer_id != multiplayer.get_unique_id():
	#		_player_left_a_side.rpc_id(peer_id, index)
	_manage_start_button(false)

func _on_panel_state_changed(index):
	self.relay.message_broadcast({
		"type": "player_panel_updated",
		"index": index,
		"ap": self.player_panels[index].ap,
		"team": self.player_panels[index].team,
		"ptype": self.player_panels[index].type
	})
	#for peer_id in self.multiplayer_srv.players:
	#	if peer_id != multiplayer.get_unique_id():
	#		_update_panel_state.rpc_id(peer_id, index, self.player_panels[index].ap, self.player_panels[index].team, self.player_panels[index].type)
	_manage_start_button(false)

func _on_panel_swap(index):
	self.relay.message_broadcast({
		"type": "player_panel_swap",
		"index": index
	})
	#for peer_id in self.multiplayer_srv.players:
	#	if peer_id != multiplayer.get_unique_id():
	#		_swap_panel.rpc_id(peer_id, index)

#@rpc("any_peer", "reliable")
func _player_joined_a_side(peer_id, index):
	self.player_panels[index]._set_peer_id(peer_id)
	_manage_start_button(false)

#@rpc("any_peer", "reliable")
func _player_left_a_side(index):
	self.player_panels[index]._set_peer_id(null)
	_manage_start_button(false)

#@rpc("any_peer", "reliable")
func _set_lobby_state(state):
	self.server_state = state

func _apply_server_state():
	var int_index
	if self.server_state != null:
		for index in self.server_state:
			int_index = int(index)
			if self.player_panels[int_index].is_visible():
				self.player_panels[int_index].fill_panel(self.server_state[index]["side"])
				if self.server_state[index]["peer_id"] != null:
					self.player_panels[int_index]._set_peer_id(int(self.server_state[index]["peer_id"]))
				self.player_panels[int_index]._set_ap(int(self.server_state[index]["ap"]))
				self.player_panels[int_index]._set_team(self.server_state[index]["team"])
				self.player_panels[int_index]._set_type(self.server_state[index]["type"])
	self.server_state = null

#@rpc("any_peer", "reliable")
func _update_panel_state(index, ap, team, type):
	self.player_panels[index]._set_ap(ap)
	self.player_panels[index]._set_team(team)
	self.player_panels[index]._set_type(type)

#@rpc("any_peer", "reliable")
func _swap_panel(index):
	self.player_panels[index]._perform_panel_swap()






func load_game_from_state(state):
	self.match_setup.reset()

	self.match_setup.map_name = state["map_name"]
	self.match_setup.restore_save_id = "multiplayer"
	self.match_setup.is_multiplayer = true
	for player in state["players"]:
		self.match_setup.add_player(
			player["side"],
			player["ap"],
			player["type"],
			player["alive"],
			player["team"],
			player["peer_id"]
		)

	self.switcher.board_online()
