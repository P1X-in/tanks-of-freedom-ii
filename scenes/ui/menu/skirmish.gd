extends Control

@onready var map_list_service = $"/root/MapManager"



@onready var start_button = $"widgets/start_button"
@onready var player_panels = [
	$"widgets/skirmish_player_0",
	$"widgets/skirmish_player_1",
	$"widgets/skirmish_player_2",
	$"widgets/skirmish_player_3",
]

@onready var minimap = $"widgets/minimap"
@onready var animations = $"animations"

var hq_templates = [
	"modern_hq",
	"steampunk_hq",
	"futuristic_hq",
	"feudal_hq",
]

var main_menu
var map_name
var cache = {}

func bind_menu(menu):
	self.main_menu = menu

func _ready():
	self.set_process_input(false)    

func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed('editor_menu'):
		self._on_back_button_pressed()

func show_panel(selected_map_name):
	self.animations.play("show")
	self.set_process_input(true)
	self.fill_map_data(selected_map_name)
	self.map_name = selected_map_name
	await self.get_tree().create_timer(0.1).timeout
	self.start_button.grab_focus()


func hide_panel():
	self.animations.play("hide")
	self.set_process_input(false)

func fill_map_data(fill_name):
	self.minimap.fill_minimap(fill_name)
	self._fill_player_panels(fill_name)

func _hide_player_panels():
	for panel in self.player_panels:
		panel.hide()
		panel._reset_labels()

func _fill_player_panels(fill_name):
	self._hide_player_panels()

	var sides = self._gather_player_sides(self._get_map_data(fill_name))

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


func _on_start_button_pressed():
	SimpleAudioLibrary.play("menu_click")

	MatchSetup.reset()
	MatchSetup.map_name = self.map_name

	for player in self.player_panels:
		if player.side != null:
			MatchSetup.add_player(player.side, player.ap, player.type, true, player.team)

	SceneSwitcher.board()


func _on_back_button_pressed():
	SimpleAudioLibrary.play("menu_back")
	self.main_menu.close_skirmish()

func _get_map_data(fill_name):
	if self.cache.has(fill_name):
		return self.cache[fill_name]

	var map_data = self.map_list_service.get_map_data(fill_name)

	self.cache[fill_name] = map_data

	return map_data
