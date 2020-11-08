extends Node

const LIST_FILE_PATH = "user://known_maps_list.json"
const MAP_PATH = "user://"
const MAP_EXTENSION = ".tofmap.json"

var filesystem = preload("res://scripts/services/filesystem.gd").new()

var maps = {}

func _ready():
    self.load_list_from_file()

func add_map_to_list(map_name, online_id=null):
    var key = map_name

    if online_id != null:
        key += "_" + online_id

    self.maps[key] = {
        "name" : map_name,
        "online_id" : online_id,
    }

    self.save_list_to_file()

func save_list_to_file():
    self.filesystem.write_data_as_json_to_file(self.LIST_FILE_PATH, self.maps)

func load_list_from_file():
    self.maps = self.filesystem.read_json_from_file(self.LIST_FILE_PATH)

func get_maps_page(page_number):
    return []

func map_exists(map_name):
    var filepath = self.MAP_PATH + map_name + self.MAP_EXTENSION
    return self.filesystem.file_exists(filepath)
