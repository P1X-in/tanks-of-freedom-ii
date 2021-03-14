extends Control

onready var menu = $"options/menu"
onready var logo = $"logo/logo_view"
onready var picker = $"map_picker/picker"
onready var skirmish = $"skirmish/skirmish"

func bind_menu(main_menu):
    self.menu.bind_menu(main_menu)
    self.skirmish.bind_menu(main_menu)

func hide_menu():
    self.menu.hide()
    #self.logo.hide()

func show_menu():
    self.menu.show()
    #self.logo.show()
    self.menu.skirmish_button.grab_focus()

func show_picker():
    self.picker.show_picker()

func hide_picker():
    self.picker.hide_picker()

func show_skirmish(map_name):
    self.skirmish.show_panel(map_name)

func hide_skirmish():
    self.skirmish.hide_panel()
