extends Node

const MAX_MAP_SIZE = 40
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

func get_maps_page(page_number, page_size):
    var pages_count = self.get_pages_count(page_size)

    if page_number >= pages_count:
        return []

    var index_start = page_number * page_size 
    var index_end = index_start + page_size

    var map_key_list = self.maps.keys()
    map_key_list.sort()

    if index_end > map_key_list.size():
        index_end = map_key_list.size()

    var index = index_start
    var output = []

    while index < index_end:
        output.append(map_key_list[index])
        index += 1

    return output

func get_pages_count(page_size):
    var total_map_count = self.maps.keys().size()
    var last_page_overflow = total_map_count % page_size
    var pages_count = (total_map_count - last_page_overflow) / page_size

    if last_page_overflow > 0:
        pages_count += 1

    return pages_count

func map_exists(map_name):
    var filepath = self.MAP_PATH + map_name + self.MAP_EXTENSION
    return self.filesystem.file_exists(filepath)

func get_map_data(map_name):
    var filepath = self.MAP_PATH + map_name + self.MAP_EXTENSION
    return self.filesystem.read_json_from_file(filepath)

func get_map_details(map_key):
    return self.maps[map_key]
