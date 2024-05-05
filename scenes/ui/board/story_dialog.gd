extends Node2D



@onready var text = $"background/text"
@onready var continue_button = $"background/continue"

@onready var left_actor = $"background/actor_left"
@onready var left_actor_portrait = $"background/actor_left/actor_view"
@onready var left_actor_name = $"background/actor_left/name"

@onready var right_actor = $"background/actor_right"
@onready var right_actor_portrait = $"background/actor_right/actor_view"
@onready var right_actor_name = $"background/actor_right/name"

func show_panel():
	self.show()
	self.call_deferred("_continue_grab_focus")

func set_actor(actor_details):
	self.left_actor.hide()
	self.left_actor_portrait.clear()
	self.right_actor.hide()
	self.right_actor_portrait.clear()
	
	if actor_details['side'] == 'left':
		self.left_actor.show()
		self.left_actor_name.set_text(actor_details['name'])
		self.left_actor_portrait.set_tile(actor_details['portrait_tile'], 90)
	elif actor_details['side'] == 'right':
		self.right_actor.show()
		self.right_actor_name.set_text(actor_details['name'])
		self.right_actor_portrait.set_tile(actor_details['portrait_tile'], 0)

func set_text(dialog_text):
	self.text.set_text(dialog_text)

func set_font_size(font_size):
	self.text.label_settings.font_size = font_size

func _continue_grab_focus():
	self.continue_button.grab_focus()

func _on_continue_pressed():
	SimpleAudioLibrary.play("menu_click")
	self.hide()
