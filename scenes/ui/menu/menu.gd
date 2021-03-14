extends Control

onready var skirmish_button = $"skirmish_button"
onready var quit_button = $"quit_button"
onready var editor_button = $"editor_button"
onready var gamepad_adapter = $"/root/GamepadAdapter"

onready var switcher = $"/root/SceneSwitcher"
onready var audio = $"/root/SimpleAudioLibrary"

var main_menu

func _ready():
    self.skirmish_button.grab_focus()

func bind_menu(menu):
    self.main_menu = menu

func _on_skirmish_button_pressed():
    self.main_menu.open_picker()

func _on_editor_button_pressed():
    self.audio.stop()
    self.gamepad_adapter.disable()
    self.switcher.map_editor()

func _on_quit_button_pressed():
    self.get_tree().quit()
