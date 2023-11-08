extends "res://scenes/ui/menu/base_menu_panel.gd"

@onready var multiplayer_srv = $"/root/Multiplayer"
@onready var map_list_service = $"/root/MapManager"
@onready var switcher = $"/root/SceneSwitcher"
@onready var match_setup = $"/root/MatchSetup"
@onready var start_button = $"widgets/start_button"
@onready var minimap = $"widgets/minimap"
@onready var player_panels = [
	$"widgets/lobby_player_0",
	$"widgets/lobby_player_1",
	$"widgets/lobby_player_2",
	$"widgets/lobby_player_3",
]
var hq_templates = [
	"modern_hq",
	"steampunk_hq",
	"futuristic_hq",
	"feudal_hq",
]

func _ready():
	super._ready()
	self.multiplayer_srv.player_connected.connect(_on_player_connected)
	self.multiplayer_srv.player_disconnected.connect(_on_player_disconnected)
	self.multiplayer_srv.server_disconnected.connect(_on_server_disconnected)


func show_panel():
	super.show_panel()

	if self.map_list_service._is_online(self.multiplayer_srv.selected_map):
		self._fill_map_data(self.multiplayer_srv.selected_map)
		await self.get_tree().create_timer(0.1).timeout
		self.start_button.grab_focus()
	else:
		self._download_map_data(self.multiplayer_srv.selected_map)

func _download_map_data(map_name):
	return

func _fill_map_data(fill_name):
	self.minimap.fill_minimap(fill_name)
	self._fill_player_panels(fill_name)

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
	super._on_back_button_pressed()
	
	self.multiplayer_srv.close_game()
	self.main_menu.close_multiplayer_lobby()

func _on_player_connected(peer_id, player_info):
	print(peer_id)
	print(player_info)

func _on_player_disconnected(peer_id):
	print(peer_id)

func _on_server_disconnected():
	_on_back_button_pressed()


func _on_start_button_pressed():
	self.audio.play("menu_click")
