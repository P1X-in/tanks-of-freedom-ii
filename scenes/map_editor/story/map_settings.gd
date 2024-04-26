extends Control

@onready var skip_initial_hq_cam_label = $"skip_initial_hq_cam/skip_initial_hq_cam_toggle/label"
@onready var initial_cam_pos_x = $"initial_cam_position/x"
@onready var initial_cam_pos_y = $"initial_cam_position/y"
@onready var track_label = $"track/track_button/label"
@onready var allow_level_up_label = $"allow_level_up/allow_level_up_toggle/label"
@onready var audio = $"/root/SimpleAudioLibrary"

signal picker_requested(context)

var skip_initial_hq_cam = false
var initial_cam_pos = null
var track = null
var allow_level_up = true


const tracks = [
	"soundtrack_1",
	"soundtrack_2",
	"soundtrack_3",
	"soundtrack_4",
	"soundtrack_5",
	"soundtrack_6",
]


func show_panel():
	self.show()
	_update_skip_initial_hq_cam_label()
	_update_initial_cam_pos_inputs()
	_update_track_label()
	_update_allow_level_up_label()


func ingest_metadata(metadata):
	if metadata.has("skip_initial_hq_cam"):
		self.skip_initial_hq_cam = metadata["skip_initial_hq_cam"]
	else:
		self.skip_initial_hq_cam = false
	_update_skip_initial_hq_cam_label()

	if metadata.has("initial_cam_pos"):
		self.initial_cam_pos = metadata["initial_cam_pos"]
	else:
		self.initial_cam_pos = null
	_update_initial_cam_pos_inputs()

	if metadata.has("track"):
		self.track = metadata["track"]
	else:
		self.track = null
	_update_track_label()
	
	if metadata.has("allow_level_up"):
		self.allow_level_up = metadata["allow_level_up"]
	else:
		self.allow_level_up = true
	_update_allow_level_up_label()


func fill_metadata(metadata):
	if self.skip_initial_hq_cam:
		metadata["skip_initial_hq_cam"] = self.skip_initial_hq_cam
	else:
		metadata.erase("skip_initial_hq_cam")

	if self.initial_cam_pos != null:
		metadata["initial_cam_pos"] = self.initial_cam_pos
	else:
		metadata.erase("initial_cam_pos")

	if self.track:
		metadata["track"] = self.track
	else:
		metadata.erase("track")
		
	if not self.allow_level_up:
		metadata["allow_level_up"] = self.allow_level_up
	else:
		metadata.erase("allow_level_up")

	return metadata


func _update_skip_initial_hq_cam_label():
	if self.skip_initial_hq_cam:
		self.skip_initial_hq_cam_label.set_text("TR_ON")
	else:
		self.skip_initial_hq_cam_label.set_text("TR_OFF")

func _update_allow_level_up_label():
	if self.allow_level_up:
		self.allow_level_up_label.set_text("TR_ON")
	else:
		self.allow_level_up_label.set_text("TR_OFF")
		
func _update_initial_cam_pos_inputs():
	if self.initial_cam_pos != null:
		initial_cam_pos_x.set_text(str(self.initial_cam_pos[0]))
		initial_cam_pos_y.set_text(str(self.initial_cam_pos[1]))
	else:
		initial_cam_pos_x.set_text("")
		initial_cam_pos_y.set_text("")

func _update_track_label():
	if self.track != null:
		self.track_label.set_text(self.track)
	else:
		self.track_label.set_text("TR_RANDOM")

func _on_skip_initial_hq_cam_toggle_pressed():
	self.audio.play("menu_click")
	self.skip_initial_hq_cam = not self.skip_initial_hq_cam
	_update_skip_initial_hq_cam_label()


func _on_track_button_pressed():
	self.audio.play("menu_click")
	if self.track == null:
		self.track = self.tracks[0]
	else:
		var index = self.tracks.find(self.track)
		if index < 0:
			self.track = null
			return

		if (index + 1) < self.tracks.size():
			self.track = self.tracks[index + 1]
		else:
			self.track = null
	_update_track_label()


func _on_text_changed(_new_text):
	var x = self.initial_cam_pos_x.get_text()
	var y = self.initial_cam_pos_y.get_text()

	if x != null and x != "" and y != null and y != "":
		self.initial_cam_pos = [int(x), int(y)]
	else:
		self.initial_cam_pos = null
	

func _on_picker_button_pressed():
	self.audio.play("menu_click")
	self.picker_requested.emit({
		"tab": "settings",
		"type": "position",
		"position": self.initial_cam_pos
	})

func _handle_picker_response(response, context):
	if context["type"] == "position":
		self.initial_cam_pos = [response.x, response.y]
		_update_initial_cam_pos_inputs()

func _on_allow_level_up_toggle_pressed():
	self.audio.play("menu_click")
	self.allow_level_up = not self.allow_level_up
	_update_allow_level_up_label()
