extends Node2D

onready var audio = $"/root/SimpleAudioLibrary"

onready var text = $"background/text"
onready var continue_button = $"background/continue"

func show_panel():
    self.show()
    self.call_deferred("_continue_grab_focus")

func set_text(dialog_text):
    self.text.set_text(dialog_text)

func _continue_grab_focus():
    self.continue_button.grab_focus()

func _on_continue_pressed():
    self.audio.play("menu_click")
    self.hide()
