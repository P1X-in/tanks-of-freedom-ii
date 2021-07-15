extends "res://scenes/ui/menu/base_menu_panel.gd"

onready var back_button = $"widgets/back_button"

func load_mission(_campaign_name, _mission_no):
    return

func _on_back_button_pressed():
    ._on_back_button_pressed()
    self.main_menu.close_campaign_mission()

func show_panel():
    .show_panel()
    yield(self.get_tree().create_timer(0.1), "timeout")
    self.back_button.grab_focus()
