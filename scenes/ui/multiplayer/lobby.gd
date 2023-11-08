extends "res://scenes/ui/menu/base_menu_panel.gd"

func _ready():
    super._ready()
    
func _on_back_button_pressed():
    super._on_back_button_pressed()
    
    self.main_menu.close_multiplayer_lobby()