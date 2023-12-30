extends Control

@onready var wrapper = $"objective_wrapper"
@onready var animations = $"animations"
@onready var background = $"objective_wrapper/background"

@onready var objectives = [
	$"objective_wrapper/obj1",
	$"objective_wrapper/obj2",
	$"objective_wrapper/obj3",
	$"objective_wrapper/obj4"
]
var raw_text = [null, null, null, null]


func clear():
	for slot in self.objectives:
		self._clear_slot(slot)

func set_objective_slot(slot, text):
	self.raw_text[slot] = text
	self.objectives[slot].set_text(text)
	self.objectives[slot].show()

func clear_objective_slot(slot):
	self._clear_slot(self.objectives[slot])

func _clear_slot(slot):
	slot.set_text("")
	slot.hide()

func restore_from_state(state):
	for i in range(self.objectives.size()):
		if state[i] != null:
			self.set_objective_slot(i, state[i])

func flash():
	if not self.animations.is_playing():
		self.animations.play("flash")

func fade_in():
	if not self.background.is_visible():
		self.animations.play("show")

func fade_out():
	if self.background.is_visible():
		self.animations.play("hide")
