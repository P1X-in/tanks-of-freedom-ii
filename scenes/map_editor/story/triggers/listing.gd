extends Control

const PAGE_SIZE = 10

signal trigger_created(new_trigger_name)
signal page_load_requested(page_no)
signal edit_requested(trigger_name)
signal trigger_data_updated(trigger_name, trigger_data)
signal trigger_removal_requested(trigger_name)
signal picker_requested(context)

@onready var prev_button = $"list_prev"
@onready var next_button = $"list_next"
@onready var add_button = $"new_trigger/add_button"
@onready var audio = $"/root/SimpleAudioLibrary"

var list_elements = []
var current_page = 0

var edit_panels = {}

func _ready():
	for element in $"elements".get_children():
		self.list_elements.append(element)
		element.edit_requested.connect(self._on_edit_requested)
	for edit_panel in $"edit_panels".get_children():
		self.edit_panels[str(edit_panel.name)] = edit_panel
		edit_panel.hide()
		edit_panel.trigger_data_updated.connect(self._on_trigger_data_updated)
		edit_panel.trigger_removal_requested.connect(self._on_trigger_removal_requested)
		edit_panel.picker_requested.connect(self._on_picker_requested)

func _hide_edit_panels():
	for edit_panel in self.edit_panels.values():
		edit_panel.hide()

func _switch_to_edit_panel(panel_name, trigger_name, trigger_data):
	_hide_edit_panels()
	if self.edit_panels.has(panel_name):
		self.edit_panels[panel_name].show_panel()
		self.edit_panels[panel_name].fill_trigger_data(trigger_name, trigger_data)

func show_panel():
	self.show()

func _clear_page():
	for element in self.list_elements:
		element.hide()

func _slice_page(names_list, page_no):
	var paging = _normalize_page_no(names_list.size(), page_no)
	page_no = paging[0]
	
	return names_list.slice(page_no * self.PAGE_SIZE, (page_no + 1) * self.PAGE_SIZE)

func _fill_page(list_slice):
	var range_size = min(self.PAGE_SIZE, list_slice.size())
	for index in range(range_size):
		self.list_elements[index].set_trigger_name(list_slice[index])
		self.list_elements[index].show()

func _manage_buttons(list_size, page_no):
	var paging = _normalize_page_no(list_size, page_no)
	self.current_page = paging[0]
	if paging[0] == 0:
		self.prev_button.hide()
	else:
		self.prev_button.show()
	if paging[1]:
		self.next_button.hide()
	else:
		self.next_button.show()


func _normalize_page_no(list_size, page_no, index_search = -1):
	if list_size == 0:
		return [0, true]
	var full_pages = list_size / self.PAGE_SIZE
	var page_overflow = list_size % self.PAGE_SIZE
	var all_pages = full_pages
	if (page_overflow > 0):
		all_pages += 1

	if index_search >= 0:
		@warning_ignore("integer_division")
		page_no = index_search / self.PAGE_SIZE

	page_no = max(page_no, 0)
	page_no = min(page_no, all_pages - 1)
	
	return [page_no, page_no == all_pages - 1]

func _find_trigger_page(names_list, trigger_name):
	var index = names_list.find(trigger_name)
	var paging = _normalize_page_no(names_list.size(), 0, index)
	return paging[0]

func show_page(names_list, page_no):
	_clear_page()
	_fill_page(_slice_page(names_list, page_no))
	_manage_buttons(names_list.size(), page_no)

func refresh_page(names_list):
	self.show_page(names_list, self.current_page)
	_switch_to_edit_panel("none", "", {})

func show_trigger_page(names_list, trigger_name):
	self.show_page(names_list, _find_trigger_page(names_list, trigger_name))

func edit_trigger(trigger_name, trigger_data):
	var edit_panel = "type_selector"
	if trigger_data["type"] != null:
		edit_panel = trigger_data["type"]
	_switch_to_edit_panel(edit_panel, trigger_name, trigger_data)
	print_debug(trigger_name, " ", trigger_data)

func _on_edit_requested(trigger_name):
	self.audio.play("menu_click")
	self.edit_requested.emit(trigger_name)


func _on_list_prev_pressed():
	self.audio.play("menu_click")
	self.page_load_requested.emit(self.current_page - 1)


func _on_list_next_pressed():
	self.audio.play("menu_click")
	self.page_load_requested.emit(self.current_page + 1)


func _on_add_button_pressed():
	self.audio.play("menu_click")
	self.trigger_created.emit($"new_trigger/name".get_text())

func _on_trigger_data_updated(trigger_name, trigger_data):
	self.trigger_data_updated.emit(trigger_name, trigger_data)

	if self.edit_panels["type_selector"].is_visible() or trigger_data["type"] == null:
		self.edit_trigger(trigger_name, trigger_data)
		self.add_button.grab_focus()

func _on_trigger_removal_requested(trigger_name):
	self.trigger_removal_requested.emit(trigger_name)
	self.add_button.grab_focus()

func _on_picker_requested(context):
	self.picker_requested.emit(context)

func _handle_picker_response(response, context):
	if context.has("trigger_type"):
		self.edit_panels[context["trigger_type"]]._handle_picker_response(response, context)
