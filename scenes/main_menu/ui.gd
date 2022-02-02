extends Control

onready var menu = $"options/menu"
onready var logo = $"logo/logo_view"
onready var picker = $"map_picker/picker"
onready var skirmish = $"skirmish/skirmish"
onready var settings = $"settings/settings"
onready var controls = $"controls/controls"
onready var campaign_selection = $"campaign_selection/campaign_selection"
onready var campaign_mission_selection = $"campaign_mission_selection/campaign_mission_selection"
onready var campaign_mission = $"campaign_mission/campaign_mission"

func bind_menu(main_menu):
    self.menu.bind_menu(main_menu)
    self.skirmish.bind_menu(main_menu)
    self.settings.bind_menu(main_menu)
    self.controls.bind_menu(main_menu)
    self.campaign_selection.bind_menu(main_menu)
    self.campaign_mission_selection.bind_menu(main_menu)
    self.campaign_mission.bind_menu(main_menu)

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
