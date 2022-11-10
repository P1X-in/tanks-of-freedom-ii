extends Control

onready var wrapper = $"objective_wrapper"

onready var objectives = [
    $"objective_wrapper/obj1",
    $"objective_wrapper/obj2",
    $"objective_wrapper/obj3",
    $"objective_wrapper/obj4"
]


func clear():
    for slot in self.objectives:
        self._clear_slot(slot)

func set_objective_slot(slot, text):
    self.objectives[slot].set_text(text)
    self.objectives[slot].show()

func clear_objective_slot(slot):
    self._clear_slot(self.objectives[slot])

func _clear_slot(slot):
    slot.set_text("")
    slot.hide()