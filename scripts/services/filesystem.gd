
var file

func _init():
    self.file = File.new()

func file_exists(filepath):
    return self.file.file_exists(filepath)

func read_json_from_file(filepath):
    if not self.file.file_exists(filepath):
        return {}

    self.file.open(filepath, File.READ)
    var content = file.get_as_text()
    file.close()
    content = JSON.parse(content)

    if content.error == OK:
        return content.result

    return {}

func write_data_as_json_to_file(filepath, data):
    var content = JSON.print(data, "", true)

    self.file.open(filepath, File.WRITE)
    self.file.store_string(content)
    self.file.close()
