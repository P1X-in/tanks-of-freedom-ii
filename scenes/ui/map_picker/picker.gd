extends Node2D

const MODE_NAME = "name"
const MODE_SELECT = "select"

const PAGE_SIZE = 10

onready var audio = $"/root/SimpleAudioLibrary"
onready var animations = $"animations"

onready var name_group = $"widgets/name"
onready var map_name_field = $"widgets/name/map_name"
onready var save_button = $"widgets/name/save_button"
onready var load_button = $"widgets/name/load_button"
onready var cancel_button = $"widgets/cancel_button"
onready var next_button = $"widgets/list_next"
onready var prev_button = $"widgets/list_prev"

onready var map_list_service = $"/root/MapList"
onready var gamepad_adapter = $"/root/GamepadAdapter"

onready var map_selection_buttons = [
    $"widgets/map_list/map0",
    $"widgets/map_list/map1",
    $"widgets/map_list/map2",
    $"widgets/map_list/map3",
    $"widgets/map_list/map4",
    $"widgets/map_list/map5",
    $"widgets/map_list/map6",
    $"widgets/map_list/map7",
    $"widgets/map_list/map8",
    $"widgets/map_list/map9",
]
onready var minimap = $"widgets/minimap"


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
    self.audio.play("menu_click")
    if self.bound_success_object != null:
        var args = [] + self.bound_success_args

        args.append(map_name)
        args.append(context)
        self.bound_success_object.call_deferred(self.bound_success_method, args)

func execute_load():
    self.audio.play("menu_click")
    var map_name = self.map_name_field.get_text()

    if map_name == "" || map_name == null:
        return

    if not self.map_list_service.map_exists(map_name):
        return

    self.execute_success(map_name, "load")
    

func execute_save():
    self.audio.play("menu_click")
    var map_name = self.map_name_field.get_text()

    if map_name == "" || map_name == null:
        return

    self.execute_success(map_name, "save")

func execute_cancel():
    self.audio.play("menu_click")
    if self.bound_cancel_object != null:
        if self.bound_cancel_args.size() > 0:
            self.bound_cancel_object.call_deferred(self.bound_cancel_method, self.bound_cancel_args)
        else:
            self.bound_cancel_object.call_deferred(self.bound_cancel_method)

func show_picker():
    self.animations.play("show")
    self.set_process_input(true)

    self.refresh_current_maps_page()
    if self.map_selection_buttons[0].is_visible():
        self.map_selection_buttons[0].grab_focus()
    elif self.name_group.is_visible():
        self.save_button.grab_focus()
    else:
        self.cancel_button.grab_focus()

    self.gamepad_adapter.enable()


func hide_picker():
    self.animations.play("hide")
    self.set_process_input(false)
    self.gamepad_adapter.disable()

func set_map_name(name):
    self.map_name_field.set_text(name)

func refresh_current_maps_page():
    var pages_count = self.map_list_service.get_pages_count(self.PAGE_SIZE)

    if self.current_page == 0 || pages_count < 2:
        self.prev_button.hide()
    elif self.current_page > 0:
        self.prev_button.show()
        

    if self.current_page == pages_count - 1 || pages_count < 2:
        self.next_button.hide()
    elif self.current_page < pages_count - 1:
        self.next_button.show()

    for map_button in self.map_selection_buttons:
        map_button.hide()

    var maps_page = self.map_list_service.get_maps_page(self.current_page, self.PAGE_SIZE)
    var map_details
        
    for index in range(maps_page.size()):
        map_details = self.map_list_service.get_map_details(maps_page[index])
        self.map_selection_buttons[index].fill_data(map_details["name"], map_details["online_id"])
        self.map_selection_buttons[index].show()

func switch_to_prev_page():
    self.audio.play("menu_click")
    if self.current_page > 0:
        self.current_page -= 1

    self.refresh_current_maps_page()

    if self.current_page == 0:
        if self.next_button.is_visible():
            self.next_button.grab_focus()


func switch_to_next_page():
    self.audio.play("menu_click")
    var pages_count = self.map_list_service.get_pages_count(self.PAGE_SIZE)

    if self.current_page < pages_count - 1:
        self.current_page += 1

    self.refresh_current_maps_page()

    if self.current_page == pages_count - 1:
        if self.prev_button.is_visible():
            self.prev_button.grab_focus()


func map_button_pressed(name):
    self.audio.play("menu_click")
    if self.operation_mode == self.MODE_NAME:
        self.set_map_name(name)
        self.load_button.grab_focus()
    elif self.operation_mode == self.MODE_SELECT:
        self.execute_success(name, "select")

func map_button_focused(name):
    minimap.fill_minimap(name)

func connect_buttons():
    self.cancel_button.connect("pressed", self, "execute_cancel")

    self.save_button.connect("pressed", self, "execute_save")
    self.load_button.connect("pressed", self, "execute_load")

    self.next_button.connect("pressed", self, "switch_to_next_page")
    self.prev_button.connect("pressed", self, "switch_to_prev_page")

    for button in self.map_selection_buttons:
        button.bind_method(self, "map_button_pressed")
        button.bind_focus(self, "map_button_focused")
