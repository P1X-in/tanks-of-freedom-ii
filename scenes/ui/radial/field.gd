extends Node2D

onready var background = $"background"
onready var white_outline = $"white"
onready var disabled = $"disabled"
onready var cd_label = $"disabled/cd"

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
        $"icon_anchor".add_child(self.icon)

    self.bound_object = new_bound_object
    self.bound_method = new_bound_method
    self.bound_args = new_bound_args

func set_disabled(cooldown=null):
    self.disabled.show()

    if cooldown != null:
        self.cd_label.set_text(str(cooldown))
    else:
        self.cd_label.set_text("")

func clear():
    if self.icon != null:
        self.icon.queue_free()

    self.icon = null
    self.label = ""
    self.set_visible(false)
    self.disabled.hide()

    self.bound_object = null
    self.bound_method = null
    self.bound_args = []

func focus():
    self.background.set_modulate(self.full_background)
    self.white_outline.show()
    self.focused = true

func unfocus():
    self.background.set_modulate(self.default_background)
    self.white_outline.hide()
    self.focused = false

func is_assigned():
    return self.label != ""

func execute_bound_method():
    if self.bound_object != null:
        if self.bound_args.size() > 0:
            self.bound_object.call_deferred(self.bound_method, self.bound_args)
        else:
            self.bound_object.call_deferred(self.bound_method)
