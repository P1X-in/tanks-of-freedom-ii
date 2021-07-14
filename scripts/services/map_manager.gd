extends Node

const MAX_MAP_SIZE = 40
const LIST_FILE_PATH = "user://known_maps_list.json"
const MAP_PATH = "user://"
const BUNDLED_MAP_PATH = "res://assets/maps/"
const MAP_EXTENSION = ".tofmap.json"
const MAIN_MENU_MAP_NAME = "main_menu_bg"

var filesystem = preload("res://scripts/services/filesystem.gd").new()

var maps = {}
var bundled_maps = {
    "crossroad": {"name": "crossroad", "online_id" : null}, 
    "crossroad2": {"name": "crossroad2", "online_id" : null}
}

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

func get_maps_page(page_number, page_size):
    var pages_count = self.get_pages_count(page_size)

    if page_number >= pages_count:
        return []

    var index_start = page_number * page_size 
    var index_end = index_start + page_size

    var map_key_list = self.maps.keys()
    map_key_list.sort()

    if index_end > _get_maps_count():
        index_end = _get_maps_count()

    var index = index_start
    var output = []

    while index < index_end:
        if index < map_key_list.size():
            output.append(map_key_list[index])
        else:
            output.append(bundled_maps.keys()[index])
        index += 1

    return output

func _get_maps_count():
    return self.maps.keys().size() + self.bundled_maps.keys().size()

func get_pages_count(page_size):
    var total_map_count = _get_maps_count()
    var last_page_overflow = total_map_count % page_size
    var pages_count = (total_map_count - last_page_overflow) / page_size

    if last_page_overflow > 0:
        pages_count += 1

    return pages_count

func map_exists(map_name):
    if bundled_maps.has(map_name):
        return true
    var filepath = self.MAP_PATH + map_name + self.MAP_EXTENSION
    return self.filesystem.file_exists(filepath)

func get_map_data(map_name):
    var filepath = get_map_path(map_name)
    return self.filesystem.read_json_from_file(filepath)

func save_map_to_file(filename, content):
    var filepath = get_map_path(filename)
    self.filesystem.write_data_as_json_to_file(filepath, content)

func get_map_path(map_name):
    if bundled_maps.has(map_name) or map_name == MAIN_MENU_MAP_NAME:
        return self.BUNDLED_MAP_PATH + map_name + self.MAP_EXTENSION
    else:
        return self.MAP_PATH + map_name + self.MAP_EXTENSION

func get_map_details(map_key):
    if bundled_maps.has(map_key):
        return self.bundled_maps[map_key]
    return self.maps[map_key]