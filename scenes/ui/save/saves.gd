extends Node2D

const PAGE_SIZE = 10


@onready var animations = $"animations"

@onready var save_button = $"widgets/save_button"
@onready var load_button = $"widgets/load_button"
@onready var new_save_button = $"widgets/new_save_button"
@onready var cancel_button = $"widgets/cancel_button"
@onready var next_button = $"widgets/list_next"
@onready var prev_button = $"widgets/list_prev"







@onready var entry_buttons = [
	$"widgets/save_list/entry0",
	$"widgets/save_list/entry1",
	$"widgets/save_list/entry2",
	$"widgets/save_list/entry3",
	$"widgets/save_list/entry4",
	$"widgets/save_list/entry5",
	$"widgets/save_list/entry6",
	$"widgets/save_list/entry7",
	$"widgets/save_list/entry8",
	$"widgets/save_list/entry9",
]

var bound_success_object = null
var bound_success_method = null
var bound_success_args = []

var bound_cancel_object = null
var bound_cancel_method = null
var bound_cancel_args = []

var board

var save_mode = true
var current_page = 0
var selected_save_id = null


func _ready():
	self.set_process_input(false)
	for button in self.entry_buttons:
		button.bind_method(self, "entry_button_pressed")

func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed('editor_menu'):
		self.execute_cancel()
	if event.is_action_pressed("ui_page_down"):
		self.switch_to_next_page()
		if self.entry_buttons[0].is_visible():
			self.entry_buttons[0].grab_focus()
	if event.is_action_pressed("ui_page_up"):
		self.switch_to_prev_page()
		if self.entry_buttons[0].is_visible():
			self.entry_buttons[0].grab_focus()

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

func execute_new_save():
	SimpleAudioLibrary.play("menu_click")
	var save_data = SavesManager.compile_save_data(self.board)
	SavesManager.add_new_save(
		save_data["map_name"],
		save_data["map_label"],
		save_data["turn_no"],
		save_data["save_data"]
	)
	self.current_page = 0
	self.refresh_current_entries_page()

func save_pressed():
	if self.selected_save_id == null:
		return
	SimpleAudioLibrary.play("menu_click")
	self.save_state_to_id(self.selected_save_id)
	self.refresh_current_entries_page()

func load_pressed():
	if self.selected_save_id == null:
		return
	SimpleAudioLibrary.play("menu_click")
	self.load_state_from_id(self.selected_save_id)

func entry_button_pressed(save_id, button):
	SimpleAudioLibrary.play("menu_click")
	self.selected_save_id = save_id

	for entry_button in self.entry_buttons:
		if entry_button != button:
			entry_button.hide_stars()

	self.load_button.show()
	if self.save_mode:
		self.save_button.show()
	await self.get_tree().create_timer(0.1).timeout
	self.load_button.grab_focus()

func execute_cancel():
	SimpleAudioLibrary.play("menu_back")
	if self.bound_cancel_object != null:
		if self.bound_cancel_args.size() > 0:
			self.bound_cancel_object.call_deferred(self.bound_cancel_method, self.bound_cancel_args)
		else:
			self.bound_cancel_object.call_deferred(self.bound_cancel_method)

func execute_success(map_name, context=null):
	SimpleAudioLibrary.play("menu_click")
	if self.bound_success_object != null:
		var args = [] + self.bound_success_args

		args.append(map_name)
		args.append(context)
		self.bound_success_object.call_deferred(self.bound_success_method, args)

func show_saves(set_save_mode):
	self.animations.play("show")
	self.set_process_input(true)

	self.save_mode = set_save_mode

	self.save_button.hide()
	self.load_button.hide()

	if self.save_mode:
		self.new_save_button.show()
	else:
		self.new_save_button.hide()

	self.refresh_current_entries_page()
	await self.get_tree().create_timer(0.1).timeout
	if self.entry_buttons[0].is_visible():
		self.entry_buttons[0].grab_focus()
	elif self.save_mode:
		self.new_save_button.grab_focus()
	else:
		self.cancel_button.grab_focus()

	GamepadAdapter.enable()


func hide_saves():
	self.animations.play("hide")
	self.set_process_input(false)
	GamepadAdapter.disable()

func refresh_current_entries_page():
	var pages_count = SavesManager.get_pages_count(self.PAGE_SIZE)

	if self.current_page == 0 || pages_count < 2:
		self.prev_button.hide()
	elif self.current_page > 0:
		self.prev_button.show()


	if self.current_page == pages_count - 1 || pages_count < 2:
		self.next_button.hide()
	elif self.current_page < pages_count - 1:
		self.next_button.show()

	self.selected_save_id = null
	self.save_button.hide()
	self.load_button.hide()
	for entry_button in self.entry_buttons:
		entry_button.hide()
		entry_button.hide_stars()

	var entries_page = SavesManager.get_entries_page(self.current_page, self.PAGE_SIZE)
	var entry

	for index in range(entries_page.size()):
		entry = entries_page[index]
		self.entry_buttons[index].fill_data(
			entry["label"],
			entry["save_id"],
			entry["turn"],
			entry["created_at"]
		)
		self.entry_buttons[index].show()

func switch_to_prev_page():
	SimpleAudioLibrary.play("menu_click")
	if self.current_page > 0:
		self.current_page -= 1

	self.refresh_current_entries_page()

	if self.current_page == 0:
		if self.next_button.is_visible():
			self.next_button.grab_focus()


func switch_to_next_page():
	SimpleAudioLibrary.play("menu_click")
	var pages_count = SavesManager.get_pages_count(self.PAGE_SIZE)

	if self.current_page < pages_count - 1:
		self.current_page += 1

	self.refresh_current_entries_page()

	if self.current_page == pages_count - 1:
		if self.prev_button.is_visible():
			self.prev_button.grab_focus()

func save_state_to_id(save_id):
	var save_data = SavesManager.compile_save_data(self.board)

	SavesManager.overwrite_save(
		save_data["map_name"],
		save_data["map_label"],
		save_data["turn_no"],
		save_data["save_data"],
		save_id
	)

func perform_autosave():
	var save_data = SavesManager.compile_save_data(self.board)
	save_data["map_label"] = tr("TR_AUTOSAVE") + " - " + save_data["map_label"]

	SavesManager.write_autosave(
		save_data["map_name"],
		save_data["map_label"],
		save_data["turn_no"],
		save_data["save_data"]
	)

func load_state_from_id(save_id):
	var save_data = SavesManager.get_save_data(save_id)
	MatchSetup.reset()

	MatchSetup.restore_save_id = save_id
	MatchSetup.map_name = save_data["map_name"]
	MatchSetup.campaign_name = save_data["campaign_name"]
	MatchSetup.mission_no = save_data["mission_no"]
	MatchSetup.stored_setup = save_data["initial_setup"]
	for player in save_data["players"]:
		MatchSetup.add_player(
			player["side"],
			player["ap"],
			player["type"],
			player["alive"],
			player["team"]
		)

	GamepadAdapter.disable()
	SceneSwitcher.board()
