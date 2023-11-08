extends "res://scenes/ui/menu/base_menu_panel.gd"

@onready var main_panel = $"widgets/main"
@onready var address_panel = $"widgets/address"
@onready var nickname_input = $"widgets/main/nickname"

@onready var settings = $"/root/Settings"

func _ready():
	super._ready()
	self.nickname_input.set_text(self.settings.get_option("nickname"))
	
func _on_back_button_pressed():
	super._on_back_button_pressed()
	
	if self.address_panel.is_visible():
		self.address_panel.hide()
		self.main_panel.show()
	else:
		self.main_menu.close_multiplayer()


func _on_create_button_pressed():
	self.audio.play("menu_click")
	self.main_menu.open_multiplayer_picker()


func _on_join_button_pressed():
	self.main_panel.hide()
	self.address_panel.show()


func _on_nickname_focus_exited():
	self.settings.set_option("nickname", self.nickname_input.get_text())


func _on_connect_button_pressed():
	pass # Replace with function body.
