
const PATH = "user://maps/"
const EXTENSION = ".tofmap.json"

var map

func _init(map):
	self.map = map

func save_map_file(filename):
	var content = JSON.print(self.map.model.get_dict(), "", true)
	self.save_to_file(filename, content)

func save_to_file(filename, content):
	var file = File.new()
    file.open(self.PATH + filename + self.EXTENSION, File.WRITE)
    file.store_string(content)
    file.close()

func load_map_file(filename):
	var file = File.new()
    file.open("user://save_game.dat", File.READ)
    var content = file.get_as_text()
    file.close()
    return content
