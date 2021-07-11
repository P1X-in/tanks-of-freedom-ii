extends Node

const SETTINGS_FILE_PATH = "user://settings.json"

var filesystem = preload("res://scripts/services/filesystem.gd").new()

var settings = {
    "fullscreen" : false,
}


func _ready():
    self.load_settings_from_file()

func save_settings_to_file():
    self.filesystem.write_data_as_json_to_file(self.SETTINGS_FILE_PATH, self.settings)

func load_settings_from_file():
    var loaded_settings = self.filesystem.read_json_from_file(self.SETTINGS_FILE_PATH)

    for settings_key in loaded_settings:
        self.settings[settings_key] = loaded_settings[settings_key]

func set_option(key, value):
    self.settings[key] = value
    self.save_settings_to_file()
