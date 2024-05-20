extends Control

@onready var audio = $"/root/SimpleAudioLibrary"

@onready var animations = $"animations"
@onready var back_button = $"widgets/back_button"

var main_menu

func bind_menu(menu):
	self.main_menu = menu

func _ready():
	self.set_process_input(false)  
	
func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed('editor_menu'):
		self._on_back_button_pressed()

func _on_back_button_pressed():
	self.audio.play("menu_back")
	self.main_menu.close_credits()

func show_panel():
	self.animations.play("show")
	self.set_process_input(true)
	await self.get_tree().create_timer(0.1).timeout
	self.back_button.grab_focus()

func hide_panel():
	self.animations.play("hide")
	self.set_process_input(false)
