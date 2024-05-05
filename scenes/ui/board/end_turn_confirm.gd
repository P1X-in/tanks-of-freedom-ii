extends Node2D

@onready var no_button = $"no_button"
@onready var yes_button = $"yes_button"





var board = null


func show_panel():
	self.show()
	GamepadAdapter.enable()
	self.no_button.grab_focus()

func _on_no_button_pressed():
	SimpleAudioLibrary.play("menu_back")
	GamepadAdapter.disable()
	self.board.close_end_turn_confirm_panel()


func _on_yes_button_pressed():
	SimpleAudioLibrary.play("menu_click")
	GamepadAdapter.disable()
	self.board.close_end_turn_confirm_panel()
	self.board.end_turn()

