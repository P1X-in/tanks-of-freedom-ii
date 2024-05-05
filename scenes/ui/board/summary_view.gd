extends Node2D

@onready var menu_button = $"menu_button"
@onready var restart_button = $"restart_button"
@onready var next_mission_button = $"next_mission_button"
@onready var next_mission_button_label = $"next_mission_button/label"

@onready var mission_complete = $"background/mission_complete"
@onready var mission_failed = $"background/mission_failed"

@onready var blue_wins = $"background/blue_wins"
@onready var red_wins = $"background/red_wins"
@onready var green_wins = $"background/green_wins"
@onready var yellow_wins = $"background/yellow_wins"
@onready var black_wins = $"background/black_wins"








func configure_winner(winner):
	GamepadAdapter.enable()
	self.restart_button.show()

	if MatchSetup.campaign_win:
		if MatchSetup.has_won:
			self.mission_complete.show()
			self._setup_next_mission()
			self.next_mission_button.grab_focus()
			SimpleAudioLibrary.play("fanfare")
		else:
			self.mission_failed.show()
			self.restart_button.grab_focus()
			SimpleAudioLibrary.play("failfare")
	else:
		match winner:
			"blue":
				self.blue_wins.show()
			"red":
				self.red_wins.show()
			"yellow":
				self.yellow_wins.show()
			"green":
				self.green_wins.show()
			"black":
				self.black_wins.show()

		self.menu_button.grab_focus()
		SimpleAudioLibrary.play("fanfare")

func disable_restart():
	self.restart_button.hide()
	self.menu_button.grab_focus()

func _setup_next_mission():
	self.next_mission_button.show()
	if Campaign.is_campaign_complete(MatchSetup.campaign_name):
		self.next_mission_button_label.set_text("TR_FINISH")

func _on_menu_button_pressed():
	GamepadAdapter.disable()
	MatchSetup.reset()
	Multiplayer.close_game()
	SceneSwitcher.main_menu()
	SimpleAudioLibrary.play("menu_click")


func _on_restart_button_pressed():
	GamepadAdapter.disable()
	if MatchSetup.restore_save_id != null:
		MatchSetup.restore_save_id = null
		MatchSetup.restore_setup()
	MatchSetup.has_won = false
	SceneSwitcher.board()
	SimpleAudioLibrary.play("menu_click")

func _on_next_mission_button_pressed():
	if Campaign.is_campaign_complete(MatchSetup.campaign_name):
		MatchSetup.animate_medal = true
	GamepadAdapter.disable()
	SceneSwitcher.main_menu()
	SimpleAudioLibrary.play("menu_click")
