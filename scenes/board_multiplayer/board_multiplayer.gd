extends "res://scenes/board/board.gd"

@onready var multiplayer_srv = $"/root/Multiplayer"

var all_players_loaded = false

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
	print("all loaded")
	print(_can_current_player_perform_actions())


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
	super.setup_radial_menu(context_object)

	if context_object == null:
		self.ui.radial.set_field_disabled(0, "X")
		self.ui.radial.set_field_disabled(2, "X")

func _add_player_to_state(data):
	self.state.add_player(data["type"], data["side"], data["alive"], data["team"], data["peer_id"])

func main_menu():
	self.multiplayer_srv.close_game()
	super.main_menu()
