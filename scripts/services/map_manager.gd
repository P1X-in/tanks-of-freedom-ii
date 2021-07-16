extends Node

const MAX_MAP_SIZE := 40
const LIST_FILE_PATH := "user://known_maps_list.json"
const MAP_PATH := "user://"
const BUNDLED_MAP_PATH := "res://assets/maps/"
const MAP_EXTENSION := ".tofmap.json"
const MAIN_MENU_MAP_NAME := "main_menu_bg"

var filesystem = preload("res://scripts/services/filesystem.gd").new()

var maps := {}

func _ready():
    self.load_list_from_file()
    self._load_bundled_maps()

func add_map_to_list(map_name: String, online_id=null, bundled := false):
    var key = map_name

    if online_id != null:
        key += "_" + online_id

    self.maps[key] = {
        "name" : map_name,
        "online_id" : online_id,
        "bundled" : bundled
    }
    if not bundled:
        self.save_list_to_file()

func save_list_to_file() -> void:
    #TODO remove bundled maps
    self.filesystem.write_data_as_json_to_file(self.LIST_FILE_PATH, self.maps)

func load_list_from_file() -> void:
    self.maps = self.filesystem.read_json_from_file(self.LIST_FILE_PATH)

func _load_bundled_maps() -> void:
    self.add_map_to_list("crossroad", null, true)
    self.add_map_to_list("crossroad2", null, true)

func get_maps_page(page_number: int, page_size: int) -> Array:
    var pages_count = self.get_pages_count(page_size)

    if page_number >= pages_count:
        return []

    var index_start := page_number * page_size 
    var index_end := index_start + page_size

    var map_key_list := self.maps.keys()
    map_key_list.sort()

    var maps_count: int = self.maps.keys().size()
    if index_end > maps_count:
        index_end = maps_count

    var index = index_start
    var output := []

    while index < index_end:
        output.append(map_key_list[index])
        index += 1

    return output

func get_pages_count(page_size: int) -> int:
    var total_map_count := self.maps.size()
    var last_page_overflow := total_map_count % page_size
    var pages_count := (total_map_count - last_page_overflow) / page_size

    if last_page_overflow > 0:
        pages_count += 1

    return pages_count

func map_exists(map_name: String) -> bool:
    if _is_bundled(map_name):
        return true
    var filepath = self.MAP_PATH + map_name + self.MAP_EXTENSION
    return self.filesystem.file_exists(filepath)

func get_map_data(map_name: String) -> Dictionary:
    var filepath := get_map_path(map_name)
    return self.filesystem.read_json_from_file(filepath)

func save_map_to_file(filename: String, content: Dictionary) -> void:
    var filepath = _get_user_map_path(filename)
    self.filesystem.write_data_as_json_to_file(filepath, content)

func get_map_path(map_name: String) -> String:
    if self._is_bundled(map_name) or map_name == MAIN_MENU_MAP_NAME:
        return self.BUNDLED_MAP_PATH + map_name + self.MAP_EXTENSION
    else:
        return _get_user_map_path(map_name)

func _get_user_map_path(map_name: String) -> String:
    return self.MAP_PATH + map_name + self.MAP_EXTENSION

func get_map_details(map_key: String) -> String:
    return self.maps[map_key]

func _is_bundled(map_name: String) -> bool:
    return self.maps.has(map_name) and self.maps[map_name].bundled