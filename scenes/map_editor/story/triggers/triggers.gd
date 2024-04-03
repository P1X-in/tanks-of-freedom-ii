extends Control

@onready var listing_panel = $Listing

signal picker_requested(context)

var triggers_data = {}

func _ready():
	self.listing_panel.trigger_created.connect(self._on_new_trigger_created)
	self.listing_panel.page_load_requested.connect(self._on_triggers_page_load_request)
	self.listing_panel.edit_requested.connect(self._on_trigger_edit_requested)
	self.listing_panel.trigger_data_updated.connect(self._on_trigger_data_updated)
	self.listing_panel.trigger_removal_requested.connect(self._on_trigger_removal_requested)
	self.listing_panel.picker_requested.connect(self._on_picker_requested)


func _switch_to_panel(panel):
	self.listing_panel.hide()
	panel.show_panel()

func show_panel():
	self.show()


func ingest_triggers_data(data):
	self.triggers_data = data
	_on_triggers_page_load_request(0)
	_switch_to_panel(self.listing_panel)
	self.listing_panel._hide_edit_panels()
	

func compile_triggers_data():
	return self.triggers_data

func _get_sorted_trigger_names():
	var trigger_names = self.triggers_data.keys()
	trigger_names.sort()
	return trigger_names

func _on_new_trigger_created(new_trigger_name):
	if new_trigger_name == "":
		return
	if not self.triggers_data.has(new_trigger_name):
		self.triggers_data[new_trigger_name] = {
			"details": {},
			"one_off": true,
			"story": null,
			"type": null
		}
	self.listing_panel.show_trigger_page(_get_sorted_trigger_names(), new_trigger_name)
	self.listing_panel.edit_trigger(new_trigger_name, self.triggers_data[new_trigger_name])
	
func _on_triggers_page_load_request(page_no):
	self.listing_panel.show_page(_get_sorted_trigger_names(), page_no)

func _on_trigger_edit_requested(trigger_name):
	self.listing_panel.edit_trigger(trigger_name, self.triggers_data[trigger_name])

func _on_trigger_data_updated(trigger_name, trigger_data):
	self.triggers_data[trigger_name] = trigger_data


func _on_trigger_removal_requested(trigger_name):
	self.triggers_data.erase(trigger_name)
	self.listing_panel.refresh_page(_get_sorted_trigger_names())

func _on_picker_requested(context):
	context["tab"] = "triggers"
	if context.has("trigger_name"):
		if self.triggers_data.has(context["trigger_name"]):
			context["trigger_type"] = self.triggers_data[context["trigger_name"]]["type"]
	self.picker_requested.emit(context)

func _handle_picker_response(response, context):
	self.listing_panel._handle_picker_response(response, context)
