extends Control

@onready var listing_panel = $Listing

signal picker_requested(context)
signal edit_requested(story_name)

var stories_data = {}

func _ready():
	self.listing_panel.story_created.connect(self._on_new_story_created)
	self.listing_panel.page_load_requested.connect(self._on_stories_page_load_request)
	self.listing_panel.edit_requested.connect(self._on_story_edit_requested)
	self.listing_panel.story_removal_requested.connect(self._on_story_removal_requested)


func _switch_to_panel(panel):
	self.listing_panel.hide()
	panel.show_panel()

func show_panel():
	self.show()


func ingest_stories_data(data):
	self.stories_data = data
	_on_stories_page_load_request(0)
	_switch_to_panel(self.listing_panel)
	

func compile_stories_data():
	return self.stories_data

func _get_sorted_stories_names():
	var stories_names = self.stories_data.keys()
	stories_names.sort()
	return stories_names

func _on_new_story_created(new_story_name):
	if new_story_name == "":
		return
	if not self.stories_data.has(new_story_name):
		self.stories_data[new_story_name] = []
	# add story edit here
	self.listing_panel.refresh_page(_get_sorted_stories_names())

func _on_stories_page_load_request(page_no):
	self.listing_panel.show_page(_get_sorted_stories_names(), page_no)


func _on_story_edit_requested(story_name):
	print("Story edit ", story_name)
	return

func _on_story_removal_requested(story_name):
	self.stories_data.erase(story_name)
	self.listing_panel.refresh_page(_get_sorted_stories_names())

func _on_picker_requested(context):
	context["tab"] = "stories"
	self.picker_requested.emit(context)

