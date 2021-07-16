extends Node

const MAX_MAP_SIZE := 40
const LIST_FILE_PATH := "user://known_maps_list.json"
const MAP_PATH := "user://"
const BUNDLED_MAP_PATH := "res://assets/maps/skirmish"
const SPECIAL_MAP_PATH := "res://assets/maps/special"
const MAP_EXTENSION := ".tofmap.json"

var filesystem = preload("res://scripts/services/filesystem.gd").new()

var maps := {}
var skirmish := {}
var special := {}

func _ready():
    self._load_bundled_maps()
    self.load_list_from_file()

func add_map_to_list(map_name: String, online_id=null) -> void:
    var key = map_name

    if online_id != null:
        key += "_" + online_id

    self.maps[key] = {
        "name" : map_name,
        "online_id" : online_id
    }
    
    self.save_list_to_file()

func save_list_to_file() -> void:
    self.filesystem.write_data_as_json_to_file(self.LIST_FILE_PATH, self.maps)

func load_list_from_file() -> void:
    self.maps = self.filesystem.read_json_from_file(self.LIST_FILE_PATH)

func _load_bundled_maps() -> void:
    self._load_bundled_skirmish_maps()
    self._load_bundled_special_maps()

func _load_bundled_skirmish_maps() -> void:
    var loaded_maps = self._load_map_names_from_dir(self.BUNDLED_MAP_PATH)
    for map_name in loaded_maps:
        self.skirmish[map_name] = {
            "name" : map_name,
            "online_id" : null
        }

func _load_bundled_special_maps() -> void:
    var loaded_maps = self._load_map_names_from_dir(self.SPECIAL_MAP_PATH)
    for map_name in loaded_maps:
        self.special[map_name] = {
            "name" : map_name,
            "online_id" : null
        }

func _load_map_names_from_dir(dir_path) -> Array:
    var names = []

    if self.filesystem.dir_exists(dir_path):
        var file_list = self.filesystem.dir_list(dir_path, true)

        for file_name in file_list:
            if file_name.ends_with(self.MAP_EXTENSION):
                names.append(file_name.replace(self.MAP_EXTENSION, ""))

    return names

func get_maps_page(page_number: int, page_size: int) -> Array:
    var pages_count = self.get_pages_count(page_size)

    if page_number >= pages_count:
        return []

    var index_start := page_number * page_size 
    var index_end := index_start + page_size

    var skirmish_key_list := self.skirmish.keys()
    skirmish_key_list.sort()
    var map_key_list := self.maps.keys()
    map_key_list.sort()

    map_key_list = skirmish_key_list + map_key_list

    var maps_count: int = self.maps.size() + self.skirmish.size()
    if index_end > maps_count:
        index_end = maps_count

    var index = index_start
    var output := []

    while index < index_end:
        output.append(map_key_list[index])
        index += 1

    return output

func get_pages_count(page_size: int) -> int:
    var total_map_count := self.maps.size() + self.skirmish.size()
    var last_page_overflow := total_map_count % page_size
    #warning-ignore:integer_division
    var pages_count := (total_map_count - last_page_overflow) / page_size

    if last_page_overflow > 0:
        pages_count += 1

    return pages_count

func map_exists(map_name: String) -> bool:
    if _is_bundled(map_name):
        return true
    var filepath = self._get_user_map_path(map_name)
    return self.filesystem.file_exists(filepath)

func get_map_data(map_name: String) -> Dictionary:
    var filepath := self.get_map_path(map_name)
    return self.filesystem.read_json_from_file(filepath)

func save_map_to_file(filename: String, content: Dictionary) -> void:
    var filepath = self._get_user_map_path(filename)
    self.filesystem.write_data_as_json_to_file(filepath, content)

func get_map_path(map_name: String) -> String:
    if self._is_bundled(map_name):
        return self.BUNDLED_MAP_PATH + "/" + map_name + self.MAP_EXTENSION
    elif self._is_special(map_name):
        return self.SPECIAL_MAP_PATH + "/" + map_name + self.MAP_EXTENSION
    else:
        return self._get_user_map_path(map_name)

func _get_user_map_path(map_name: String) -> String:
    return self.MAP_PATH + map_name + self.MAP_EXTENSION

func get_map_details(map_key: String) -> String:
    if self._is_bundled(map_key):
        return self.skirmish[map_key]
    if self._is_special(map_key):
        return self.special[map_key]
    return self.maps[map_key]

func _is_bundled(map_name: String) -> bool:
    return self.skirmish.has(map_name)

func _is_special(map_name: String) -> bool:
    return self.special.has(map_name)

func is_reserved_name(map_name: String) -> bool:
    return self._is_bundled(map_name) or self._is_special(map_name)
