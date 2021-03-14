
const USE_USER = "user"
const USE_BUNDLE = "bundle"

const PATH = "user://"
const BUNDLED_MAP_PATH = "res://assets/maps/"
const EXTENSION = ".tofmap.json"

var map
var filesystem = preload("res://scripts/services/filesystem.gd").new()

func _init(map_scene):
    self.map = map_scene

func save_map_file(filename, location="user"):
    self.save_to_file(filename, self.map.model.get_dict(), location)

func save_to_file(filename, content, location="user"):
    var filepath = self._construct_path(filename, location)
    self.filesystem.write_data_as_json_to_file(filepath, content)

func load_map_file(filename, location="user"):
    var filepath = self._construct_path(filename, location)

    if not self.filesystem.file_exists(filepath):
        return

    var content = self.filesystem.read_json_from_file(filepath)
    self.map.builder.wipe_map()
    self.map.builder.fill_map_from_data(content)

func _construct_path(filename, location):
    if location == self.USE_USER:
        return self.PATH + filename + self.EXTENSION
    elif location == self.USE_BUNDLE:
        return self.BUNDLED_MAP_PATH + filename + self.EXTENSION

