extends Control

@onready var audio = $"/root/SimpleAudioLibrary"
@onready var settings = $"/root/Settings"

@onready var animations = $"animations"

@onready var general_button = $"widgets/tabs/general"
@onready var video_button = $"widgets/tabs/video"
@onready var audio_button = $"widgets/tabs/audio"
@onready var gameplay_button = $"widgets/tabs/gameplay"
@onready var back_button = $"widgets/back_button"

@onready var general_panel = $"widgets/boxes/settings_general"
@onready var video_panel = $"widgets/boxes/settings_video"
@onready var audio_panel = $"widgets/boxes/settings_audio"
@onready var gameplay_panel = $"widgets/boxes/settings_gameplay"
@onready var multiplayer_panel = $"widgets/boxes/settings_multi"

@onready var help = $"help"
@onready var help_text = $"help/text"

var main_menu

func bind_menu(menu):
	self.main_menu = menu

func _ready():
	self.set_process_input(false)  
	
func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed('editor_menu'):
		self._on_back_button_pressed()

func _on_back_button_pressed():
	self.hide_help()
	self.audio.play("menu_back")
	self.main_menu.close_settings()

func show_panel():
	self.hide_help()
	self.general_panel.show()
	self.video_panel.hide()
	self.audio_panel.hide()
	self.gameplay_panel.hide()
	self.multiplayer_panel.hide()
	self.animations.play("show")
	self.set_process_input(true)
	await self.get_tree().create_timer(0.1).timeout
	self.general_button.grab_focus()

func hide_panel():
	self.hide_help()
	self.animations.play("hide")
	self.set_process_input(false)

func _on_general_pressed():
	self.general_panel.show()
	self.video_panel.hide()
	self.audio_panel.hide()
	self.gameplay_panel.hide()
	self.multiplayer_panel.hide()
	self.audio.play("menu_click")

func _on_video_pressed():
	self.general_panel.hide()
	self.video_panel.show()
	self.audio_panel.hide()
	self.gameplay_panel.hide()
	self.multiplayer_panel.hide()
	self.audio.play("menu_click")

func _on_audio_pressed():
	self.video_panel.hide()
	self.general_panel.hide()
	self.audio_panel.show()
	self.gameplay_panel.hide()
	self.multiplayer_panel.hide()
	self.audio.play("menu_click")

func _on_gameplay_pressed():
	self.video_panel.hide()
	self.general_panel.hide()
	self.audio_panel.hide()
	self.gameplay_panel.show()
	self.multiplayer_panel.hide()
	self.audio.play("menu_click")

func _on_multiplayer_pressed():
	self.video_panel.hide()
	self.general_panel.hide()
	self.audio_panel.hide()
	self.gameplay_panel.hide()
	self.multiplayer_panel.show()
	self.audio.play("menu_click")

func show_help(text):
	self.help_text.set_text(text)
	self.help.show()

func hide_help():
	self.help.hide()

func _on_controls_pressed():
	self.audio.play("menu_click")
	self.main_menu.open_controls()
