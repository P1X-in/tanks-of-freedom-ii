extends TextureButton

onready var label = $"label"
onready var stars = $"stars"

var save_id
var map_name
var turn_no
var created_at

var bound_object = null
var bound_method = null

func _ready():
    self.hide_stars()
    self.label.set_message_translation(false)
    self.label.notification(NOTIFICATION_TRANSLATION_CHANGED)

func fill_data(name, map_save_id, map_turn_no, map_created_at):
    self.map_name = name
    self.save_id = map_save_id
    self.turn_no = map_turn_no
    self.created_at = map_created_at

    self.refresh_label()

func refresh_label():
    var new_text = self.map_name + " - " + tr("TR_TURN") + " " + str(self.turn_no) + " - "
    new_text += str(self.created_at["year"]) + "-" + str(self.created_at["month"]) + "-" + str(self.created_at["day"])
    new_text += " " + str(self.created_at["hour"]) + ":"
    if self.created_at["minute"] < 10:
        new_text += "0"
    new_text += str(self.created_at["minute"])
    self.label.set_text(new_text)

func bind_method(new_object, new_method):
    self.bound_object = new_object
    self.bound_method = new_method

func _on_button_pressed():
    if self.bound_object != null:
        self.bound_object.call_deferred(self.bound_method, self.save_id, self)
        self.show_stars()

func show_stars():
    self.stars.show()

func hide_stars():
    self.stars.hide()
