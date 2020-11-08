extends Node2D

onready var background = $"background"

var default_background
var full_background

var icon = null
var label = ""

var focused = false

var bound_object = null
var bound_method = null
var bound_args = []

func _ready():
    self.default_background = self.background.get_modulate()
    self.full_background = Color(1, 1, 1, 1)

func set_field(new_icon, new_label, new_bound_object=null, new_bound_method=null, new_bound_args=[]):
    self.icon = new_icon
    self.label = new_label
    self.set_visible(true)

    if self.icon != null:
        self.add_child(self.icon)

    self.bound_object = new_bound_object
    self.bound_method = new_bound_method
    self.bound_args = new_bound_args

func clear():
    if self.icon != null:
        self.icon.queue_free()

    self.icon = null
    self.label = ""
    self.set_visible(false)

    self.bound_object = null
    self.bound_method = null
    self.args = []

func focus():
    self.background.set_modulate(self.full_background)
    self.focused = true

func unfocus():
    self.background.set_modulate(self.default_background)
    self.focused = false

func is_assigned():
    return self.label != ""

func execute_bound_method():
    if self.bound_object != null:
        if self.bound_args.size() > 0:
            self.bound_object.call_deferred(self.bound_method, self.bound_args)
        else:
            self.bound_object.call_deferred(self.bound_method)
