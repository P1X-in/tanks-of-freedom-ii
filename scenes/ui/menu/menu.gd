extends Control

@onready var campaign_button = $"campaign_button"
@onready var skirmish_button = $"skirmish_button"
@onready var multiplayer_button = $"multiplayer_button"
@onready var load_button = $"load_button"
@onready var editor_button = $"editor_button"
@onready var settings_button = $"settings_button"
@onready var online_button = $"online_button"
@onready var quit_button = $"quit_button"
@onready var animations = $"animations"






var main_menu
var recent_button_used = null

func _ready():
	self.set_process_input(true)
	self.campaign_button.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		self.quit_button.grab_focus()

	if OS.is_debug_build():
		if event.is_action_pressed("cheat_capture"):
			self.main_menu.ui.hide_menu()
			self.main_menu._start_intro()

func bind_menu(menu):
	self.main_menu = menu

func _on_skirmish_button_pressed():
	self.recent_button_used = self.skirmish_button
	SimpleAudioLibrary.play("menu_click")
	self.main_menu.open_picker()

func _on_multiplayer_button_pressed():
	self.recent_button_used = self.multiplayer_button
	SimpleAudioLibrary.play("menu_click")
	self.main_menu.open_multiplayer()


func _on_load_button_pressed():
	self.recent_button_used = self.load_button
	SimpleAudioLibrary.play("menu_click")
	self.main_menu.open_saves()

func _on_editor_button_pressed():
	self.recent_button_used = self.editor_button
	SimpleAudioLibrary.stop()
	GamepadAdapter.disable()
	SceneSwitcher.map_editor()

func _on_settings_button_pressed():
	self.recent_button_used = self.settings_button
	SimpleAudioLibrary.play("menu_click")
	self.main_menu.open_settings()

func _on_campaign_button_pressed():
	self.recent_button_used = self.campaign_button
	SimpleAudioLibrary.play("menu_click")
	self.main_menu.open_campaign_selection()

func _on_online_button_pressed():
	self.recent_button_used = self.online_button
	SimpleAudioLibrary.play("menu_click")
	self.main_menu.open_online()

func _on_quit_button_pressed():
	MouseLayer.destroy()
	self.get_tree().quit()

func show_panel():
	self.animations.play("show")
	self.set_process_input(true)
	await self.get_tree().create_timer(0.1).timeout

	if self.recent_button_used != null:
		self.recent_button_used.grab_focus()
	else:
		self.campaign_button.grab_focus()

func hide_panel():
	self.set_process_input(false)
	self.animations.play("hide")
