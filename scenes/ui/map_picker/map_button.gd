extends TextureButton

onready var label = $"label"
onready var downloads_label = $"downloads"

var map_name
var online_id
var downloads

var bound_object = null
var bound_method = null

var focus_object = null
var focus_method = null


func _ready():
    var _error = self.connect("pressed", self, "_on_button_pressed")
    self.label.set_message_translation(false)
    self.label.notification(NOTIFICATION_TRANSLATION_CHANGED)


func fill_data(name, map_online_id, downloads_amount=null):
    self.map_name = name
    self.online_id = map_online_id
    self.downloads = downloads_amount

    self.refresh_label()


func refresh_label():
    var new_text = self.map_name

    if self.online_id != null:
        new_text = self.online_id + " - " + new_text

    self.label.set_text(new_text)
    if self.downloads != null:
        self.downloads_label.show()
        self.downloads_label.set_text(str(self.downloads))
    else:
        self.downloads_label.hide()


func bind_method(new_object, new_method):
    self.bound_object = new_object
    self.bound_method = new_method


func bind_focus(new_object, new_method):
    self.focus_object = new_object
    self.focus_method = new_method


func _get_map_id():
    if self.online_id == null:
        return self.map_name
    return self.online_id

func _on_button_pressed():
    if self.bound_object != null:
        self.bound_object.call_deferred(self.bound_method, self._get_map_id())


func _on_focus_entered():
    if self.focus_object != null:
        self.focus_object.call_deferred(self.focus_method, self._get_map_id())

func _on_mouse_entered():
    self._on_focus_entered()
