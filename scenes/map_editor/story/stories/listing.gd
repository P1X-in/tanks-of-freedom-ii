extends Control

var _page_size

signal story_created(new_story_name)
signal page_load_requested(page_no)
signal edit_requested(story_name)
signal story_removal_requested(story_name)

@onready var prev_button = $"list_prev"
@onready var next_button = $"list_next"
@onready var add_button = $"new_story/add_button"
@onready var audio = $"/root/SimpleAudioLibrary"

var list_elements = []
var current_page = 0


func _ready():
	for element in $"elements".get_children():
		self.list_elements.append(element)
		element.edit_requested.connect(self._on_edit_requested)
		element.story_removal_requested.connect(self._on_story_removal_requested)
	self._page_size = self.list_elements.size()


func show_panel():
	self.show()

func _clear_page():
	for element in self.list_elements:
		element.hide()

func _slice_page(names_list, page_no):
	var paging = _normalize_page_no(names_list.size(), page_no)
	page_no = paging[0]
	
	return names_list.slice(page_no * self._page_size, (page_no + 1) * self._page_size)

func _fill_page(list_slice):
	var range_size = min(self._page_size, list_slice.size())
	for index in range(range_size):
		self.list_elements[index].set_story_name(list_slice[index])
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

func show_page(names_list, page_no):
	_clear_page()
	_fill_page(_slice_page(names_list, page_no))
	_manage_buttons(names_list.size(), page_no)

func refresh_page(names_list):
	self.show_page(names_list, self.current_page)

func _on_edit_requested(story_name):
	self.audio.play("menu_click")
	self.edit_requested.emit(story_name)


func _on_list_prev_pressed():
	self.audio.play("menu_click")
	self.page_load_requested.emit(self.current_page - 1)


func _on_list_next_pressed():
	self.audio.play("menu_click")
	self.page_load_requested.emit(self.current_page + 1)


func _on_add_button_pressed():
	self.audio.play("menu_click")
	self.story_created.emit($"new_story/name".get_text())

func _on_story_removal_requested(story_name):
	self.audio.play("menu_click")
	self.story_removal_requested.emit(story_name)
	self.add_button.grab_focus()
