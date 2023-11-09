extends "res://scenes/ui/menu/base_menu_panel.gd"

@onready var multiplayer_srv = $"/root/Multiplayer"
@onready var online = $"/root/Online"
@onready var map_list_service = $"/root/MapManager"
@onready var switcher = $"/root/SceneSwitcher"
@onready var match_setup = $"/root/MatchSetup"
@onready var start_button = $"widgets/start_button"
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

func _ready():
	super._ready()
	self.multiplayer_srv.player_connected.connect(_on_player_connected)
	self.multiplayer_srv.player_disconnected.connect(_on_player_disconnected)
	self.multiplayer_srv.server_disconnected.connect(_on_server_disconnected)


func show_panel():
	super.show_panel()

	if self.map_list_service._is_bundled(self.multiplayer_srv.selected_map) or self.map_list_service._is_online(self.multiplayer_srv.selected_map):
		self._fill_map_data(self.multiplayer_srv.selected_map)
		await self.get_tree().create_timer(0.1).timeout
		self.start_button.grab_focus()
	else:
		self._download_map_data(self.multiplayer_srv.selected_map)

func _download_map_data(map_name):
	self.widgets.hide()
	self.downloading_label.show()

	var result = await self.online.download_map(map_name)

	self.downloading_label.hide()
	self.widgets.show()

	if result:
		self._fill_map_data(map_name)
		await self.get_tree().create_timer(0.1).timeout
		self.start_button.grab_focus()
	else:
		_on_back_button_pressed()


func _fill_map_data(fill_name):
	self.minimap.fill_minimap(fill_name)
	self._fill_player_panels(fill_name)

func _fill_player_labels():
	for label in self.player_labels:
		label[0].hide()

	var player_info = self.multiplayer_srv.players.values()
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
	
	self.multiplayer_srv.close_game()
	self.main_menu.close_multiplayer_lobby()

func _on_player_connected(_peer_id, _player_info):
	_fill_player_labels()

func _on_player_disconnected(_peer_id):
	_fill_player_labels()

func _on_server_disconnected():
	_on_back_button_pressed()


func _on_start_button_pressed():
	self.audio.play("menu_click")
