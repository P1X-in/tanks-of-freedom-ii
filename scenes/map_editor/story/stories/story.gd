extends Control

var _page_size

signal step_created(story_name)
signal page_load_requested(story_name, page_no)
signal edit_requested(story_name, step_no)
signal step_data_updated(story_name, step_no, step_data)
signal step_removal_requested(story_name, step_no)
signal picker_requested(context)

@onready var prev_button = $"list_prev"
@onready var next_button = $"list_next"
@onready var add_button = $"new_step/add_button"
@onready var audio = $"/root/SimpleAudioLibrary"

var _story_name
var list_elements = []
var current_page = 0

var edit_panels = {}

func _ready():
	for element in $"elements".get_children():
		self.list_elements.append(element)
		element.edit_requested.connect(self._on_edit_requested)
	self._page_size = self.list_elements.size()

	for edit_panel in $"edit_panels".get_children():
		self.edit_panels[str(edit_panel.name)] = edit_panel
		edit_panel.hide()
		edit_panel.step_data_updated.connect(self._on_step_data_updated)
		edit_panel.step_removal_requested.connect(self._on_step_removal_requested)
		edit_panel.picker_requested.connect(self._on_picker_requested)

func _hide_edit_panels():
	for edit_panel in self.edit_panels.values():
		edit_panel.hide()

func _switch_to_edit_panel(panel_name, step_no, step_data):
	_hide_edit_panels()
	if self.edit_panels.has(panel_name):
		self.edit_panels[panel_name].show_panel()
		self.edit_panels[panel_name].fill_step_data(step_no, step_data)

func show_panel():
	self.show()

func _clear_page():
	for element in self.list_elements:
		element.hide()

func _slice_page(steps_list, page_no):
	var paging = _normalize_page_no(steps_list.size(), page_no)
	page_no = paging[0]
	
	return steps_list.slice(page_no * self._page_size, (page_no + 1) * self._page_size)

func _fill_page(list_slice, steps_list, page_no):
	var paging = _normalize_page_no(steps_list.size(), page_no)
	page_no = paging[0]

	var range_size = min(self._page_size, list_slice.size())
	var step_label

	for index in range(range_size):
		step_label = list_slice[index]["action"]

		if self.edit_panels.has(list_slice[index]["action"]):
			step_label = self.edit_panels[list_slice[index]["action"]].build_step_label(list_slice[index])

		self.list_elements[index].set_step_name(page_no * self._page_size + index, step_label)
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
	var full_pages = list_size / self._page_size
	var page_overflow = list_size % self._page_size
	var all_pages = full_pages
	if (page_overflow > 0):
		all_pages += 1

	if index_search >= 0:
		@warning_ignore("integer_division")
		page_no = index_search / self._page_size

	page_no = max(page_no, 0)
	page_no = min(page_no, all_pages - 1)
	
	return [page_no, page_no == all_pages - 1]

func _find_step_page(steps_list, step_no):
	var paging = _normalize_page_no(steps_list.size(), 0, step_no)
	return paging[0]

func show_page(story_name, steps_list, page_no):
	self._story_name = story_name
	_clear_page()
	_fill_page(_slice_page(steps_list, page_no), steps_list, page_no)
	_manage_buttons(steps_list.size(), page_no)

func refresh_page(story_name, steps_list):
	self.show_page(story_name, steps_list, self.current_page)
	_switch_to_edit_panel("none", "", {})

func show_step_page(story_name, steps_list, step_no):
	self.show_page(story_name, steps_list, _find_step_page(steps_list, step_no))

func edit_step(step_no, step_data):
	var edit_panel = "type_selector"
	if step_data["action"] != null:
		edit_panel = step_data["action"]
	_switch_to_edit_panel(edit_panel, step_no, step_data)

func _on_edit_requested(step_no):
	self.audio.play("menu_click")
	self.edit_requested.emit(self._story_name, step_no)


func _on_list_prev_pressed():
	self.audio.play("menu_click")
	self.page_load_requested.emit(self._story_name, self.current_page - 1)


func _on_list_next_pressed():
	self.audio.play("menu_click")
	self.page_load_requested.emit(self._story_name, self.current_page + 1)


func _on_add_button_pressed():
	self.audio.play("menu_click")
	self.step_created.emit(self._story_name)

func _on_step_data_updated(step_no, step_data):
	self.step_data_updated.emit(self._story_name, step_no, step_data)

	if self.edit_panels["type_selector"].is_visible() or step_data["action"] == null:
		self.edit_step(step_no, step_data)
		self.add_button.grab_focus()

func _on_step_removal_requested(step_no):
	self.step_removal_requested.emit(self._story_name, step_no)
	self.add_button.grab_focus()

func _on_picker_requested(context):
	context["story_name"] = self._story_name
	self.picker_requested.emit(context)

func _handle_picker_response(response, context):
	if context.has("step_type"):
		self.edit_panels[context["step_type"]]._handle_picker_response(response, context)
