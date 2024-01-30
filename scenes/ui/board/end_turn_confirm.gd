extends Node2D

@onready var no_button = $"no_button"
@onready var yes_button = $"yes_button"

@onready var gamepad_adapter = $"/root/GamepadAdapter"
@onready var audio = $"/root/SimpleAudioLibrary"


var board = null


func show_panel():
	self.show()
	self.gamepad_adapter.enable()
	self.no_button.grab_focus()

func _on_no_button_pressed():
	self.audio.play("menu_back")
	self.gamepad_adapter.disable()
	self.board.close_end_turn_confirm_panel()


func _on_yes_button_pressed():
	self.audio.play("menu_click")
	self.gamepad_adapter.disable()
	self.board.close_end_turn_confirm_panel()
	self.board.end_turn()

