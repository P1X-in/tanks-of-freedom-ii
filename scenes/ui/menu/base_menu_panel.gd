extends Control

onready var audio = $"/root/SimpleAudioLibrary"

onready var animations = $"animations"

var main_menu

func _ready():
    self.set_process_input(false)

func _input(event):
    if event.is_action_pressed("ui_cancel") or event.is_action_pressed('editor_menu'):
        self._on_back_button_pressed()

func _on_back_button_pressed():
    self.audio.play("menu_back")

func bind_menu(menu):
    self.main_menu = menu

func show_panel():
    self.animations.play("show")
    self.set_process_input(true)

func hide_panel():
    self.animations.play("hide")
    self.set_process_input(false)

