extends Node2D

onready var menu_button = $"menu_button"
onready var restart_button = $"restart_button"

onready var blue_wins = $"background/blue_wins"
onready var red_wins = $"background/red_wins"
onready var green_wins = $"background/green_wins"
onready var yellow_wins = $"background/yellow_wins"
onready var black_wins = $"background/black_wins"

onready var switcher = $"/root/SceneSwitcher"
onready var gamepad_adapter = $"/root/GamepadAdapter"
onready var audio = $"/root/SimpleAudioLibrary"

func configure_winner(winner):
    self.gamepad_adapter.enable()
    self.menu_button.grab_focus()

    match winner:
        "blue":
            self.blue_wins.show()
        "red":
            self.red_wins.show()
        "yellow":
            self.yellow_wins.show()
        "green":
            self.green_wins.show()
        "black":
            self.black_wins.show()


func _on_menu_button_pressed():
    self.gamepad_adapter.disable()
    self.switcher.main_menu()
    self.audio.play("menu_click")


func _on_restart_button_pressed():
    self.gamepad_adapter.disable()
    self.switcher.board()
    self.audio.play("menu_click")
