
const PATH = "user://"
const EXTENSION = ".tofmap.json"

var map

func _init(map_scene):
	self.map = map_scene

func save_map_file(filename):
	var content = JSON.print(self.map.model.get_dict(), "", true)
	self.save_to_file(filename, content)

func save_to_file(filename, content):
	var file = File.new()
	file.open(self.PATH + filename + self.EXTENSION, File.WRITE)
	file.store_string(content)
	file.close()

func load_map_file(filename):
	var filepath = self.PATH + filename + self.EXTENSION
	var file = File.new()

	if not file.file_exists(filepath):
		return

	file.open(filepath, File.READ)
	var content = file.get_as_text()
	file.close()

	self.build_map_from_string(content)
	
func build_map_from_string(string_data):
	var json_result = JSON.parse(string_data)

	if json_result.error == OK:
		self.map.builder.fill_map_from_data(json_result.result)

