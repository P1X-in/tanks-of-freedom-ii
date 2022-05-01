extends Control

onready var audio = $"/root/SimpleAudioLibrary"
onready var settings = $"/root/Settings"

onready var animations = $"animations"

onready var video_button = $"widgets/tabs/video"
onready var audio_button = $"widgets/tabs/audio"
onready var camera_button = $"widgets/tabs/camera"
onready var back_button = $"widgets/back_button"

onready var video_panel = $"widgets/boxes/settings_video"
onready var audio_panel = $"widgets/boxes/settings_audio"
onready var camera_panel = $"widgets/boxes/settings_camera"

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
    self.main_menu.close_settings()

func show_panel():
    self.animations.play("show")
    self.set_process_input(true)
    yield(self.get_tree().create_timer(0.1), "timeout")
    self.video_button.grab_focus()
    self.video_panel.show()
    self.audio_panel.hide()
    self.camera_panel.hide()

func hide_panel():
    self.animations.play("hide")
    self.set_process_input(false)

func _on_video_pressed():
    self.video_panel.show()
    self.audio_panel.hide()
    self.camera_panel.hide()
    self.audio.play("menu_click")

func _on_audio_pressed():
    self.video_panel.hide()
    self.audio_panel.show()
    self.camera_panel.hide()
    self.audio.play("menu_click")

func _on_camera_pressed():
    self.video_panel.hide()
    self.audio_panel.hide()
    self.camera_panel.show()
    self.audio.play("menu_click")
