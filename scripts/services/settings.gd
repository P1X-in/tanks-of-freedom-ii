extends Node

const SETTINGS_FILE_PATH = "user://settings.json"

onready var audio = $"/root/SimpleAudioLibrary"
var filesystem = preload("res://scripts/services/filesystem.gd").new()
var os_string = ""

var settings = {
    "steamdeck_detection": false,
    "is_steamdeck": false,
    "fullscreen" : true,
    "vol_master" : 10,
    "vol_sfx" : 8,
    "vol_music" : 7,
    "sound" : true,
    "music" : true,
    "hq_cam" : true,
    "cam_shake" : true,
    "def_cam_st" : "TOF",
    "shadows" : true,
    "decorations" : true,
    "dec_shadows" : true,
    "msaa": 0.0,
    "fxaa": false,
    "vsync": false,
    "fps": 144.0,
    "ips": 144.0,
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

func _apply_option(key):
    if key == "fullscreen":
        OS.set_window_fullscreen(self.settings[key])
    elif key == "sound":
        self.audio.sounds_enabled = self.settings[key]
    elif key == "music":
        self.audio.music_enabled = self.settings[key]
        if self.settings[key]:
            if not self.audio.is_playing("menu"):
                self.audio.track("menu")
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
        get_viewport().set_msaa(self._get_msaa(self.settings[key]))
    elif key == "fxaa":
        get_viewport().set_use_fxaa(self.settings[key])
    elif key == "vsync":
        OS.set_use_vsync(self.settings[key])
    elif key == "fps":
        Engine.set_target_fps(self.settings[key])
    elif key == "ips":
        Engine.set_iterations_per_second(self.settings[key])

func _set_bus_vol(name, key):
    var decibels = self._get_decibels(self.settings[key])
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(name), decibels)

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
    elif value == 16:
        return 4

func _detect_steam_deck():
    if self.settings["steamdeck_detection"]:
        return

    self.settings["steamdeck_detection"] = true
    
    if OS.get_name() == "X11":
        var output = []
        var exit_code = OS.execute("lsb_release", ["-si"], true, output)
        
        if exit_code == 0 and output.size() > 0 and output[0].strip_edges() == "SteamOS":
            self.settings["is_steamdeck"] = true
            self._apply_steam_deck_settings()

func _apply_steam_deck_settings():
    self.settings["fullscreen"] = true
    self.settings["def_cam_st"] = "FREE"
    self.settings["shadows"] = false
    self.settings["decorations"] = true
    self.settings["dec_shadows"] = false
    self.settings["msaa"] = 0.0
    self.settings["fxaa"] = false
    self.settings["vsync"] = false
    self.settings["fps"] = 30.0
    self.settings["ips"] = 60.0

    if not self.filesystem.file_exists(self.SETTINGS_FILE_PATH):
        self.save_settings_to_file()
