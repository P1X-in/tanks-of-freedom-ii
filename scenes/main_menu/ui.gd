extends Control

onready var menu = $"options/menu"
onready var logo = $"logo/logo_view"
onready var picker = $"map_picker/picker"
onready var skirmish = $"skirmish/skirmish"
onready var settings = $"settings/settings"
onready var campaign_selection = $"campaign_selection/campaign_selection"

func bind_menu(main_menu):
    self.menu.bind_menu(main_menu)
    self.skirmish.bind_menu(main_menu)
    self.settings.bind_menu(main_menu)
    self.campaign_selection.bind_menu(main_menu)

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

func show_campaign_selection():
    self.campaign_selection.show_panel()

func hide_campaign_selection():
    self.campaign_selection.hide_panel()
