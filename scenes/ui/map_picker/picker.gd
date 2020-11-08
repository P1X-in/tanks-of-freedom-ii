extends Node2D

const MODE_NAME = "name"
const MODE_SELECT = "select"

const PAGE_SIZE = 10

onready var animations = $"animations"

onready var name_group = $"widgets/name"
onready var map_name_field = $"widgets/name/map_name"
onready var save_button = $"widgets/name/save_button"
onready var load_button = $"widgets/name/load_button"

onready var cancel_button = $"widgets/cancel_button"

onready var map_list_service = $"/root/MapList"


var bound_success_object = null
var bound_success_method = null
var bound_success_args = []

var bound_cancel_object = null
var bound_cancel_method = null
var bound_cancel_args = []

var operation_mode = "name"
var current_page = 0

func _ready():
    self.connect_buttons()

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        self.execute_cancel()

func set_name_mode():
    self.operation_mode = self.MODE_NAME
    self.name_group.show()

func set_select_mode():
    self.operation_mode = self.MODE_SELECT
    self.name_group.hide()

func clear_binds():
    self.bound_success_object = null
    self.bound_success_method = null
    self.bound_success_args = []
    self.bound_cancel_object = null
    self.bound_cancel_method = null
    self.bound_cancel_args = []

func bind_success(success_object, success_method, success_args=[]):
    self.bound_success_object = success_object
    self.bound_success_method = success_method
    self.bound_success_args = success_args

func bind_cancel(cancel_object, cancel_method, cancel_args=[]):
    self.bound_cancel_object = cancel_object
    self.bound_cancel_method = cancel_method
    self.bound_cancel_args = cancel_args


func execute_success(map_name, context=null):
    if self.bound_success_object != null:
        var args = [] + self.bound_success_args

        args.append(map_name)
        args.append(context)
        self.bound_success_object.call_deferred(self.bound_success_method, args)

func execute_load():
    var map_name = self.map_name_field.get_text()

    if map_name == "" || map_name == null:
        return

    if not self.map_list_service.map_exists(map_name):
        return

    self.execute_success(map_name, "load")
    

func execute_save():
    var map_name = self.map_name_field.get_text()

    if map_name == "" || map_name == null:
        return

    self.execute_success(map_name, "save")

func execute_cancel():
    if self.bound_cancel_object != null:
        if self.bound_cancel_args.size() > 0:
            self.bound_cancel_object.call_deferred(self.bound_cancel_method, self.bound_cancel_args)
        else:
            self.bound_cancel_object.call_deferred(self.bound_cancel_method)

func show_picker():
    self.animations.play("show")
    self.set_process_input(true)
    self.save_button.grab_focus()

func hide_picker():
    self.animations.play("hide")
    self.set_process_input(false)

func set_map_name(name):
    self.map_name_field.set_text(name)


func connect_buttons():
    self.cancel_button.connect("pressed", self, "execute_cancel")

    self.save_button.connect("pressed", self, "execute_save")
    self.load_button.connect("pressed", self, "execute_load")
