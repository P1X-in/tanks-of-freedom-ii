extends Control

onready var radial = $"radial/radial"

var icons = preload("res://scenes/ui/icons/icons.gd").new()

func is_popup_open():
    return false

func is_panel_open():
    if self.radial.is_visible():
        return true
    if self.is_popup_open():
        return true

    return false

func is_radial_open():
    return self.radial.is_visible()

func show_radial():
    self.radial.show_menu()

func hide_radial():
    self.radial.hide_menu()

func toggle_radial():
    if self.radial.is_visible():
        self.hide_radial()
    else:
        self.show_radial()
