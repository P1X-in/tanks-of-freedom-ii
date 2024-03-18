extends Node
class_name MapManagerClass

const MAX_MAP_SIZE: int = 40
const LIST_FILE_PATH: String = "user://known_maps_list.json"
const ONLINE_FILE_PATH: String = "user://online_maps_list.json"
const MAP_PATH: String = "user://"
const BUNDLED_MAP_PATH: String = "res://assets/maps/skirmish"
const SPECIAL_MAP_PATH: String = "res://assets/maps/special"
const MAP_EXTENSION: String = ".tofmap.json"
const ONLINE_MAP_EXTENSION: String = ".tofmap.online.json"

const LIST_STOCK: String = "stock"
const LIST_CUSTOM: String = "custom"
const LIST_DOWNLOADED: String = "downloaded"

var filesystem: FileSystem = FileSystem.new()

var maps: Dictionary = {}
var skirmish: Dictionary = {}
var special: Dictionary = {}
var online: Dictionary = {}

func _ready() -> void:
	self._load_bundled_maps()
	self.load_list_from_file()

func add_map_to_list(map_name: String) -> void:
	self.maps[map_name] = {
		"name" : map_name,
		"online_id" : null,
		"verified" : false
	}
	self.save_list_to_file()


func add_online_map_to_list(map_name: String, code: String) -> void:
	self.online[code] = {
		"name" : map_name,
		"online_id" : code
	}
	self.save_list_to_file()


func verify_map(map_name: String, verified: bool) -> void:
	if self.maps.has(map_name):
		self.maps[map_name]["verified"] = verified
		self.save_list_to_file()

func is_verified(map_name: String) -> bool:
	if self.maps.has(map_name):
		if self.maps[map_name].has("verified"):
			return self.maps[map_name]["verified"]
	return false


func save_list_to_file() -> void:
	self.filesystem.write_data_as_json_to_file(self.LIST_FILE_PATH, self.maps)
	self.filesystem.write_data_as_json_to_file(self.ONLINE_FILE_PATH, self.online)

func load_list_from_file() -> void:
	self.maps = self.filesystem.read_json_from_file(self.LIST_FILE_PATH)
	self.online = self.filesystem.read_json_from_file(self.ONLINE_FILE_PATH)

func _load_bundled_maps() -> void:
	self._load_bundled_skirmish_maps()
	self._load_bundled_special_maps()

func _load_bundled_skirmish_maps() -> void:
	var loaded_maps: Array = self._load_map_names_from_dir(self.BUNDLED_MAP_PATH)
	for map_name: String in loaded_maps:
		self.skirmish[map_name] = {
			"name" : map_name,
			"online_id" : null
		}

func _load_bundled_special_maps() -> void:
	var loaded_maps: Array = self._load_map_names_from_dir(self.SPECIAL_MAP_PATH)
	for map_name: String in loaded_maps:
		self.special[map_name] = {
			"name" : map_name,
			"online_id" : null
		}

func _load_map_names_from_dir(dir_path: String) -> Array:
	var names: Array = []

	if self.filesystem.dir_exists(dir_path):
		var file_list: Array = self.filesystem.dir_list(dir_path, true)

		for file_name: String in file_list:
			if file_name.ends_with(self.MAP_EXTENSION):
				names.append(file_name.replace(self.MAP_EXTENSION, ""))

	return names

func get_maps_page(list: String, page_number: int, page_size: int) -> Array:
	var pages_count: int = self.get_pages_count(list, page_size)

	if page_number >= pages_count:
		return []

	var index_start: int = page_number * page_size 
	var index_end: int = index_start + page_size

	var map_key_list: Array = []
	if list == self.LIST_STOCK:
		map_key_list = self.skirmish.keys()
	elif list == self.LIST_CUSTOM:
		map_key_list = self.maps.keys()
	elif list == self.LIST_DOWNLOADED:
		map_key_list = self.online.keys()

	map_key_list.sort()

	var maps_count: int = map_key_list.size()
	if index_end > maps_count:
		index_end = maps_count

	var index: int = index_start
	var output: Array = []

	while index < index_end:
		output.append(map_key_list[index])
		index += 1

	return output

func get_pages_count(list: String, page_size: int) -> int:
	var total_map_count: int = 0
	if list == self.LIST_STOCK:
		total_map_count = self.skirmish.size()
	elif list == self.LIST_CUSTOM:
		total_map_count = self.maps.size()
	elif list == self.LIST_DOWNLOADED:
		total_map_count = self.online.size()

	var last_page_overflow: int = total_map_count % page_size
	@warning_ignore("integer_division")
	var pages_count: int = (total_map_count - last_page_overflow) / page_size

	if last_page_overflow > 0:
		pages_count += 1

	return pages_count

func map_exists(map_name: String) -> bool:
	if self.is_reserved_name(map_name):
		return true
	var filepath: String = self._get_user_map_path(map_name)
	return self.filesystem.file_exists(filepath)

func get_map_data(map_name: String) -> Dictionary:
	var filepath: String = self.get_map_path(map_name)
	return self.filesystem.read_json_from_file(filepath)

func save_map_to_file(filename: String, content: Dictionary) -> void:
	var filepath: String = self._get_user_map_path(filename)
	self.filesystem.write_data_as_json_to_file(filepath, content)

func save_online_to_file(code: String, content: Dictionary) -> void:
	var filepath: String = self._get_online_map_path(code)
	self.filesystem.write_data_as_json_to_file(filepath, content)

func get_map_path(map_name: String) -> String:
	if self._is_bundled(map_name):
		return self.BUNDLED_MAP_PATH + "/" + map_name + self.MAP_EXTENSION
	elif self._is_special(map_name):
		return self.SPECIAL_MAP_PATH + "/" + map_name + self.MAP_EXTENSION
	elif self._is_online(map_name):
		return self._get_online_map_path(map_name)
	else:
		return self._get_user_map_path(map_name)

func _get_user_map_path(map_name: String) -> String:
	return self.MAP_PATH + map_name + self.MAP_EXTENSION

func _get_online_map_path(map_code: String) -> String:
	return self.MAP_PATH + map_code + self.ONLINE_MAP_EXTENSION

func get_map_details(map_key: String) -> Dictionary:
	if self._is_bundled(map_key):
		return self.skirmish[map_key]
	if self._is_special(map_key):
		return self.special[map_key]
	if self._is_online(map_key):
		return self.online[map_key]
	return self.maps[map_key]

func _is_bundled(map_name: String) -> bool:
	return self.skirmish.has(map_name)

func _is_special(map_name: String) -> bool:
	return self.special.has(map_name)

func _is_online(map_name: String) -> bool:
	return self.online.has(map_name)

func _is_custom(map_name: String) -> bool:
	if self.is_reserved_name(map_name):
		return false
	return self.maps.has(map_name)

func is_reserved_name(map_name: String) -> bool:
	return self._is_bundled(map_name) or self._is_special(map_name) or self._is_online(map_name)
