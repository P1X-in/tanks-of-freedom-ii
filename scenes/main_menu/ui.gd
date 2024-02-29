extends Control

@onready var menu = $"options/menu"
@onready var logo = $"logo/logo_view"
@onready var picker = $"map_picker/picker"
@onready var saves = $"saves/saves"
@onready var skirmish = $"skirmish/skirmish"
@onready var settings = $"settings/settings"
@onready var controls = $"controls/controls"
@onready var campaign_selection = $"campaign_selection/campaign_selection"
@onready var campaign_mission_selection = $"campaign_mission_selection/campaign_mission_selection"
@onready var campaign_mission = $"campaign_mission/campaign_mission"
@onready var online = $"online/online"
@onready var online_lobby = $"online_lobby/lobby"
@onready var multiplayer_panel = $"multiplayer/multiplayer"
@onready var multiplayer_lobby_panel = $"multiplayer_lobby/lobby"

func bind_menu(main_menu):
	self.menu.bind_menu(main_menu)
	self.skirmish.bind_menu(main_menu)
	self.settings.bind_menu(main_menu)
	self.controls.bind_menu(main_menu)
	self.campaign_selection.bind_menu(main_menu)
	self.campaign_mission_selection.bind_menu(main_menu)
	self.campaign_mission.bind_menu(main_menu)
	self.online.bind_menu(main_menu)
	self.online_lobby.bind_menu(main_menu)
	self.multiplayer_panel.bind_menu(main_menu)
	self.multiplayer_lobby_panel.bind_menu(main_menu)

	var version_string = tr("TR_VERSION") + " v" + ProjectSettings.get_setting("application/config/version")
	if main_menu.settings._is_steam_deck():
		version_string += " SteamOS"
	else:
		version_string += " " + OS.get_name()
	self.set_version(version_string)

func hide_menu():
	self.menu.hide_panel()
	#self.logo.hide()

func show_menu():
	self.menu.show_panel()
	#self.logo.show()

func show_picker():
	self.picker.show_picker()

func hide_picker():
	self.picker.hide_picker()

func show_skirmish(map_name):
	self.skirmish.show_panel(map_name)

func hide_skirmish():
	self.skirmish.hide_panel()

func show_settings():
	self.settings.show_panel()

func hide_settings():
	self.settings.hide_panel()

func show_controls():
	self.controls.show_panel()

func hide_controls():
	self.controls.hide_panel()

func show_campaign_selection(reset_page=false):
	self.campaign_selection.show_panel()
	if reset_page:
		self.campaign_selection.show_first_page()

func hide_campaign_selection():
	self.campaign_selection.hide_panel()

func show_campaign_mission_selection(campaign_name=null):
	self.campaign_mission_selection.show_panel()
	if campaign_name != null:
		self.campaign_mission_selection.load_campaign(campaign_name)

func hide_campaign_mission_selection():
	self.campaign_mission_selection.hide_panel()

func show_campaign_mission(campaign_name, mission_no):
	self.campaign_mission.show_panel()
	self.campaign_mission.load_mission(campaign_name, mission_no)

func hide_campaign_mission():
	self.campaign_mission.hide_panel()

func set_version(value):
	$"version/version".set_text(value)

func show_saves():
	self.saves.show_saves(false)

func hide_saves():
	self.saves.hide_saves()

func show_online():
	self.online.show_panel()

func hide_online():
	self.online.hide_panel()

func show_online_lobby():
	self.online_lobby.show_panel()

func hide_online_lobby():
	self.online_lobby.hide_panel()

func show_multiplayer():
	self.multiplayer_panel.show_panel()

func hide_multiplayer():
	self.multiplayer_panel.hide_panel()

func show_multiplayer_lobby():
	self.multiplayer_lobby_panel.show_panel()

func hide_multiplayer_lobby():
	self.multiplayer_lobby_panel.hide_panel()
