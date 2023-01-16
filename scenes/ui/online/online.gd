extends "res://scenes/ui/menu/base_menu_panel.gd"

func _on_back_button_pressed():
    self.audio.play("menu_back")
    self.main_menu.close_online()

func show_panel():
    .show_panel()