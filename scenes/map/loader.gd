
const PATH = "user://"
const EXTENSION = ".tofmap.json"

var map
var filesystem = preload("res://scripts/services/filesystem.gd").new()

func _init(map_scene):
    self.map = map_scene

func save_map_file(filename):
    self.save_to_file(filename, self.map.model.get_dict())

func save_to_file(filename, content):
    var filepath = self.PATH + filename + self.EXTENSION
    self.filesystem.write_data_as_json_to_file(filepath, content)

func load_map_file(filename):
    var filepath = self.PATH + filename + self.EXTENSION

    if not self.filesystem.file_exists(filepath):
        return

    var content = self.filesystem.read_json_from_file(filepath)
    self.map.builder.wipe_map()
    self.map.builder.fill_map_from_data(content)

