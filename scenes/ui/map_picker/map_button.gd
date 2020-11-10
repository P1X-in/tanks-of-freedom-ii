extends TextureButton

onready var label = $"label"

var map_name
var online_id

var bound_object = null
var bound_method = null

var focus_object = null
var focus_method = null

func _ready():
    self.connect("pressed", self, "_on_button_pressed")

func fill_data(map_name, map_online_id):
    self.map_name = map_name
    self.online_id = map_online_id

    self.refresh_label()

func refresh_label():
    var new_text = self.map_name

    if self.online_id != null:
        new_text += "(" + self.online_id + ")"

    self.label.set_text(new_text)

func bind_method(new_object, new_method):
    self.bound_object = new_object
    self.bound_method = new_method

func bind_focus(new_object, new_method):
    self.focus_object = new_object
    self.focus_method = new_method

func _on_button_pressed():
    if self.bound_object != null:
        self.bound_object.call_deferred(self.bound_method, self.map_name)


func _on_focus_entered():
    if self.focus_object != null:
        self.focus_object.call_deferred(self.focus_method, self.map_name)
