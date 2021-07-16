
var file
var directory

func _init():
    self.file = File.new()
    self.directory = Directory.new()

func file_exists(filepath):
    return self.file.file_exists(filepath)

func _dir_exists_os(dirpath):
    var real_path = OS.get_executable_path().get_base_dir().plus_file(dirpath)
    return self.directory.dir_exists(real_path)

func _dir_exists_project(dirpath):
    return self.directory.dir_exists(dirpath)

func dir_exists(dirpath):
    return self._dir_exists_os(dirpath) or self._dir_exists_project(dirpath)

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

func dir_list(dirpath, files=false):
    if self._dir_exists_os(dirpath):
        return self._dir_list_os(dirpath, files)
    elif self._dir_exists_project(dirpath):
        return self._dir_list(dirpath, files)
    return []

func _dir_list(dirpath, files=false):
    var listing = []
    var file_name

    if self.directory.open(dirpath) == OK:
        self.directory.list_dir_begin(true)
        file_name = self.directory.get_next()

        while file_name != "":
            if self.directory.current_is_dir() and not files:
                listing.append(file_name)
            if not self.directory.current_is_dir() and files:
                listing.append(file_name)
            file_name = self.directory.get_next()
    else:
        print("Failed to open " + dirpath)

    return listing


func _dir_list_os(dirpath, files=false):
    var real_path = OS.get_executable_path().get_base_dir().plus_file(dirpath)
    return self._dir_list(real_path, files)
