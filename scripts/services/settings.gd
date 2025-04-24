extends Node

const SETTINGS_FILE_PATH = "user://settings.json"

signal changed(key, new_value)

@onready var audio = $"/root/SimpleAudioLibrary"
var filesystem = preload("res://scripts/services/filesystem.gd").new()
var os_string = ""

var settings = {
	"steamdeck_detection": false,
	"is_steamdeck": false,
	"fullscreen" : false,
	"vol_master" : 10,
	"vol_sfx" : 8,
	"vol_music" : 7,
	"sound" : true,
	"music" : true,
	"hq_cam" : false,
	"cam_shake" : true,
	"def_cam_st" : "TOF",
	"shadows" : true,
	"decorations" : true,
	"dec_shadows" : true,
	"msaa": 2.0,
	"fxaa": false,
	"vsync": false,
	"fps": 60.0,
	"ips": 60.0,
	"locale": "en",
	"notify_ap_spent": true,
	"show_intro": true,
	"show_controls": true,
	"nickname": "",
	"last_used_ip": "",
	"last_used_port": "3959",
	"game_port": 3959,
	"discovery_port": 3960,
	"edge_pan": true,
	"online_domain": "api.tof.p1x.in",
	"online_port": 443,
	"relay_domain": "api.tof.p1x.in",
	"relay_port": 9959,
	"end_turn_speed": "x1",
	"show_health": true,
	"scale_ui": true,
	"render_scale": 100,
	"tilt_shift_enabled": true
}


func _ready():
	self._detect_steam_deck()
	self.load_settings_from_file()

func save_settings_to_file():
	self.filesystem.write_data_as_json_to_file(self.SETTINGS_FILE_PATH, self.settings)

func load_settings_from_file():
	var loaded_settings = self.filesystem.read_json_from_file(self.SETTINGS_FILE_PATH)

	for settings_key in loaded_settings:
		self.settings[settings_key] = loaded_settings[settings_key]
		self._apply_option(settings_key)

func get_option(key):
	if self.settings.has(key):
		return self.settings[key]
	return null

func set_option(key, value):
	self.settings[key] = value
	self.save_settings_to_file()

	self._apply_option(key)
	self.changed.emit(key, value)

func _apply_option(key):
	if key == "fullscreen":
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (self.settings[key]) else Window.MODE_WINDOWED
	elif key == "render_scale":
		self.get_tree().root.scaling_3d_scale = float(self.settings[key]) / 100.0
	elif key == "sound":
		self.audio.sounds_enabled = self.settings[key]
	elif key == "music":
		self.audio.music_enabled = self.settings[key]
		if self.settings[key]:
			self.audio.restart_track()
		else:
			self.audio.stop()
	elif key == "vol_master":
		self._set_bus_vol("Master", key)
	elif key == "vol_sfx":
		self._set_bus_vol("SFX", key)
		self.set_option("sound", self.settings[key] > 0)
	elif key == "vol_music":
		self._set_bus_vol("Music", key)
		self.set_option("music", self.settings[key] > 0)
	elif key == "msaa":
		get_viewport().set_msaa_3d(self._get_msaa(self.settings[key]))
	elif key == "fxaa":
		if self.settings[key]:
			get_viewport().set_screen_space_aa(Viewport.ScreenSpaceAA.SCREEN_SPACE_AA_FXAA)
		else:
			get_viewport().set_screen_space_aa(Viewport.ScreenSpaceAA.SCREEN_SPACE_AA_DISABLED)
	elif key == "vsync":
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (self.settings[key]) else DisplayServer.VSYNC_DISABLED)
	elif key == "fps":
		Engine.set_max_fps(self.settings[key])
	elif key == "ips":
		Engine.set_physics_ticks_per_second(self.settings[key])
		Engine.set_max_physics_steps_per_frame(self.settings[key])
	elif key == "locale":
		TranslationServer.set_locale(self.settings[key])
	elif key == "scale_ui":
		if self.settings[key]:
			get_window().set_content_scale_mode(Window.CONTENT_SCALE_MODE_CANVAS_ITEMS)
			get_window().set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_KEEP_HEIGHT)
		else:
			get_window().set_content_scale_mode(Window.CONTENT_SCALE_MODE_DISABLED)
			get_window().set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_KEEP)

func _set_bus_vol(bus_name, key):
	var decibels = self._get_decibels(self.settings[key])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), decibels)

func _get_decibels(value):
	if value == 10:
		return 0
	elif value == 9:
		return -6
	elif value == 8:
		return -12
	elif value == 7:
		return -18
	elif value == 6:
		return -24
	elif value == 5:
		return -30
	elif value == 4:
		return -36
	elif value == 3:
		return -42
	elif value == 2:
		return -48
	elif value == 1:
		return -54
	elif value == 0:
		return -80

func _get_msaa(value):
	if value == 0:
		return 0
	elif value == 2:
		return 1
	elif value == 4:
		return 2
	elif value == 8:
		return 3
	#elif value == 16:
	#	return 4

func _detect_steam_deck():
	if self.settings["steamdeck_detection"]:
		return

	self.settings["steamdeck_detection"] = true

	if _is_steam_deck():
		self.settings["is_steamdeck"] = true
		self._apply_steam_deck_settings()

func _is_steam_deck():
	return OS.get_distribution_name() == "SteamOS"

func _apply_steam_deck_settings():
	self.settings["fullscreen"] = true
	self.settings["def_cam_st"] = "TOF"
	self.settings["shadows"] = false
	self.settings["decorations"] = true
	self.settings["dec_shadows"] = false
	self.settings["msaa"] = 0.0
	self.settings["fxaa"] = false
	self.settings["vsync"] = false
	self.settings["fps"] = 60.0
	self.settings["ips"] = 60.0

	if not self.filesystem.file_exists(self.SETTINGS_FILE_PATH):
		self.save_settings_to_file()
