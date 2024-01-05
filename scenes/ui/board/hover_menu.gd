extends Control

const FADE_OUT_TIME = 3.0

@onready var animations = $"animations"

var board = null
var fade_out_timer = 0.0
var hover_stack = 0

var hovered_button = null

func _ready():
	pass # Replace with function body.

func _input(event):
	if not get_window().has_focus():
		return

	if self.board == null:
		return

	if event is InputEventMouseMotion:
		self.fade_out_timer = 0.0
		if self._should_pop_up():
			self._fade_in()

	if self.is_visible():
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			self.call_deferred("_perform_action")

func _should_pop_up():
	return not self.is_visible() and self.board._can_current_player_perform_actions() and not self.board.ui.radial.is_visible() and not self.board.ui.is_popup_open()

func _should_clear():
	return self.is_visible() and (not self.board._can_current_player_perform_actions() or self.board.ui.radial.is_visible() or self.board.ui.is_popup_open())


func _physics_process(delta):
	if self.board == null:
		return

	if self.board.selected_tile != null:
		if self.board.selected_tile.building.is_present():
			$"build_button".show()
		else:
			$"build_button".hide()

		if self.board.selected_tile.unit.is_present():
			$"stats_button".show()
			if self.board.selected_tile.unit.tile.has_active_ability():
				$"skills_button".show()
			else:
				$"skills_button".hide()
		else:
			$"stats_button".hide()
			$"skills_button".hide()
	else:
		$"build_button".hide()
		$"stats_button".hide()
		$"skills_button".hide()


	if self.is_visible() and self.fade_out_timer > self.FADE_OUT_TIME:
		self._fade_out()

	if self._should_clear():
		self._fade_out()

	self.fade_out_timer += delta


func _fade_in():
	self.hover_stack = 0
	self.animations.play("show")

func _fade_out():
	self.hover_stack = 0
	self.animations.play("hide")

func _on_mouse_click_mouse_entered(button):
	if self.board == null:
		return

	self.hover_stack += 1
	self.hovered_button = button

	if button == "turn":
		$"turn_button/white".show()
	elif button == "build":
		$"build_button/button_anchor/white".show()
	elif button == "stats":
		$"stats_button/button_anchor/white".show()
	elif button == "skills":
		$"skills_button/button_anchor/white".show()

		
func _on_mouse_click_mouse_exited(button):
	if self.board == null:
		return

	self.hover_stack -= 1
	if self.hovered_button == button:
		self.hovered_button = null

	if button == "turn":
		$"turn_button/white".hide()
	elif button == "build":
		$"build_button/button_anchor/white".hide()
	elif button == "stats":
		$"stats_button/button_anchor/white".hide()
	elif button == "skills":
		$"skills_button/button_anchor/white".hide()

func _perform_action():
	if self.board == null:
		return

	if self.hovered_button == "turn":
		self.board.end_turn()
		self._fade_out()
	elif self.hovered_button == "build":
		self.board._show_contextual_select_radial(true)
	elif self.hovered_button == "stats":
		self.board._open_context_panel_for_active_tile()
	elif self.hovered_button == "skills":
		self.board._show_contextual_select_radial(true)

	self.hovered_button = null
