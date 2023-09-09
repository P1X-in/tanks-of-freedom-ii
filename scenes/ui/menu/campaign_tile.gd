extends Control

@onready var audio = $"/root/SimpleAudioLibrary"

@onready var button = $"button"
@onready var icon_anchor = $"icon_anchor"
@onready var label = $"label"
@onready var tick = $"tick"

var main_menu
var attached_icon = null
var campaign_name

func bind_menu(menu):
	self.main_menu = menu

func set_up(visible_name, icon, _campaign_name):
	self.campaign_name = _campaign_name
	self.label.set_text(visible_name)
	self._set_icon(icon)
	self.button.set_disabled(false)
	self.tick.hide()

func set_locked(icon):
	self.label.set_text("TR_LOCKED")
	self._set_icon(icon)
	self.button.set_disabled(true)
	self.tick.hide()

func set_complete():
	self.tick.show()

func focus_tile():
	self.button.grab_focus()

func _set_icon(icon):
	if self.attached_icon != null:
		self.attached_icon.queue_free()
		self.attached_icon = null

	if icon != null:
		self.icon_anchor.add_child(icon)
		#icon.set_scale(Vector2(2, 2))
		self.attached_icon = icon

func _on_button_pressed():
	self.audio.play("menu_click")
	self.main_menu.open_campaign_mission_selection(self.campaign_name)
	self.main_menu.ui.campaign_selection.last_campaign_tile_clicked = self
