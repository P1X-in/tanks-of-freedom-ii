extends Control

signal picker_requested(context)

var stories_data = {}

func _ready():
	return


func _switch_to_panel(panel):
	panel.show_panel()

func show_panel():
	self.show()


func ingest_stories_data(data):
	self.stories_data = data
	

func compile_stories_data():
	return self.stories_data

func _get_sorted_stories_names():
	var stories_names = self.stories_data.keys()
	stories_names.sort()
	return stories_names

func _on_picker_requested(context):
	context["tab"] = "stories"
	self.picker_requested.emit(context)

