extends Node

const SETTINGS_FILE_PATH = "user://settings.json"

onready var audio = $"/root/SimpleAudioLibrary"
var filesystem = preload("res://scripts/services/filesystem.gd").new()

var settings = {
    "fullscreen" : false,
    "sound" : true,
    "music" : true,
}


func _ready():
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
            self.audio.track("menu")
        else:
            self.audio.stop()
