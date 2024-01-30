extends Node

var RELAY_PORT: int = 9939
var RELAY_URL: String = "api.tof.p1x.in"

signal connection_failed
signal connection_success
signal session_success
signal player_connected(peer_id: int, player_info: Dictionary)
signal player_disconnected(peer_id: int)
signal server_disconnected
signal all_players_loaded
signal message_received(message_data: Dictionary)

@onready var map_list_service: Node = $"/root/MapManager"
@onready var settings: Node = $"/root/Settings"
@onready var socket: WebSocketPeer = WebSocketPeer.new()

var players: Dictionary = {}
var players_loaded: int = 0

var player_limit: int = 0
var selected_map: String = ""
var match_in_progress: bool = false
var match_state: Dictionary = {}
var match_state_available: bool = false

var peer_id: int = 0
var join_code: String = ""
var connecting: bool = false

func _ready() -> void:
	self._read_settings()
	self.settings.changed.connect(self._on_settings_changed)
	self.set_process(false)
	self.message_received.connect(self._message_received)


func _on_settings_changed(key: String, _value) -> void:
	if key == "relay_port" or key == "relay_domain":
		self._read_settings()


func _read_settings() -> void:
	self.RELAY_PORT = int(self.settings.get_option("relay_port"))
	self.RELAY_URL = self.settings.get_option("relay_domain")

func is_server():
	return self.peer_id == 1

func create_game(map_name: String) -> Error:
	self.players.clear()
	self.player_limit = _get_player_count(map_name)

	self.connecting = true
	self.socket.connect_to_url("ws://" + self.RELAY_URL + ":" + str(self.RELAY_PORT))
	self.set_process(true)
	await self.connection_success

	self.selected_map = map_name
	self._send_message("host", {
		"map_name": map_name,
		"max_players": self.player_limit,
	})

	return OK

func connect_game(server_join_code: String) -> Error:
	self.connecting = true
	self.socket.connect_to_url(self.RELAY_URL + ":" + str(self.RELAY_PORT))
	self.set_process(true)
	await self.connection_success

	self.join_code = server_join_code
	self._join_session(server_join_code)

	return OK

func close_game() -> void:
	self.players.clear()
	self.players_loaded = 0
	self.match_in_progress = false
	self.match_state.clear()
	self.match_state_available = false
	self.peer_id = 0
	self.connecting = false
	self.socket.close()

func message_direct(target_peer_id: int, payload: Dictionary) -> Error:
	return _send_message("message_direct", {
		"join_code" : self.join_code,
		"source_id" : self.peer_id,
		"target_id": target_peer_id,
		"message": payload
	})

func message_broadcast(payload: Dictionary) -> Error:
	return _send_message("message_broadcast", {
		"join_code" : self.join_code,
		"source_id" : self.peer_id,
		"message": payload
	})

func game_start() -> Error:
	return _send_message("game_start", {
		"join_code" : self.join_code
	})

func player_loaded() -> void:
	if self.is_server():
		mark_player_loaded()
	else:
		self.message_direct(1, {
			"type": "player_loaded"
		})

func mark_player_loaded() -> void:
	players_loaded += 1
	if players_loaded == players.size():
		all_players_loaded.emit()
		players_loaded = 0

func _send_message(action: String, payload: Dictionary) -> Error:
	var message_data: Dictionary = {
		"action": action,
		"payload": payload
	}

	return self.socket.send_text(JSON.stringify(message_data))


func _process(_delta) -> void:
	self.socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if self.connecting:
			self.connection_success.emit()
			self.connecting = false
		while socket.get_available_packet_count():
			var raw_message: String = socket.get_packet().get_string_from_utf8()
			var test_json_conv: JSON = JSON.new()
			test_json_conv.parse(raw_message)
			self.message_received.emit(test_json_conv.get_data())
	elif state == WebSocketPeer.STATE_CLOSING:
		pass # Keep polling to achieve proper close.
	elif state == WebSocketPeer.STATE_CLOSED:
		if OS.is_debug_build():
			var code: int = socket.get_close_code()
			var reason: String = socket.get_close_reason()
			print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		self.set_process(false)
		_on_server_disconnected()


func _message_received(message: Dictionary) -> void:
	if OS.is_debug_build():
		print("Message: ", message)
	if message["action"] == "hosted":
		self.join_code = message["payload"]["join_code"]
		self._join_session(self.join_code)
	if message["action"] == "joined":
		if message["payload"]["peer_id"] == 0:
			self._on_connection_failed()
		else:
			self.peer_id = int(message["payload"]["peer_id"])
			if self.peer_id > 1:
				self.match_in_progress = message["payload"]["in_progress"]
				self.selected_map = message["payload"]["map_name"]
			self._on_player_connected({
				"peer_id": message["payload"]["peer_id"],
				"player_data" : self._get_player_info()
			})
			self.session_success.emit()
	if message["action"] == "player_joined":
		self._on_player_connected(message["payload"])
	if message["action"] == "player_disconnected":
		self._on_player_disconnected(int(message["payload"]["peer_id"]))
	if message["action"] == "session_closed":
		self._on_server_disconnected()


func _join_session(session_code: String) -> void:
	self._send_message("join", {
		"join_code": session_code,
		"player_data": self._get_player_info()
	})

func _on_player_connected(payload: Dictionary) -> void:
	var new_player_id = int(payload["peer_id"])
	players[new_player_id] = payload["player_data"]
	player_connected.emit(new_player_id, payload["player_data"])

func _on_player_disconnected(disconnected_peer_id: int) -> void:
	self.players.erase(disconnected_peer_id)
	print(self.players)
	player_disconnected.emit(disconnected_peer_id)

func _on_server_disconnected() -> void:
	self.close_game()
	server_disconnected.emit()

func _on_connection_failed() -> void:
	self.close_game()
	connection_failed.emit()

func _get_player_info() -> Dictionary:
	return {
		"name": self.settings.get_option("nickname"),
	}

func _get_player_count(map_name: String) -> int:
	var map_data = self.map_list_service.get_map_data(map_name)

	var sides = {}
	var side
	var key

	for y in range(self.map_list_service.MAX_MAP_SIZE):
		for x in range(self.map_list_service.MAX_MAP_SIZE):
			key = str(x) + "_" + str(y)
			if map_data["tiles"].has(key):
				side = self._lookup_side(map_data["tiles"][key])

				if side != "":
					sides[side] = side
	return clampi(sides.size(), 1, 4)

func _lookup_side(data: Dictionary) -> String:
	var hq_templates = [
		"modern_hq",
		"steampunk_hq",
		"futuristic_hq",
		"feudal_hq",
	]

	if data["building"]["tile"] != null:
		if data["building"]["tile"] in hq_templates:
			return data["building"]["side"]

	return ""


func _set_match_state(state: Dictionary) -> void:
	self.match_state = state
	self.match_state_available = true
