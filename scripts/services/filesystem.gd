
func file_exists(filepath):
	return FileAccess.file_exists(filepath)

func _dir_exists_os(dirpath):
	var real_path = OS.get_executable_path().get_base_dir().path_join(dirpath)
	return self._dir_exists_project(real_path)

func _dir_exists_project(dirpath):
	var dir = DirAccess.open(dirpath)
	if dir == null:
		return false
	return true

func dir_exists(dirpath):
	return self._dir_exists_os(dirpath) or self._dir_exists_project(dirpath)

func read_json_from_file(filepath):
	if not FileAccess.file_exists(filepath):
		return {}

	var file = FileAccess.open(filepath, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var test_json_conv = JSON.new()
	test_json_conv.parse(content)
	content = test_json_conv.get_data()

	if content != null:
		return content

	return {}

func write_data_as_json_to_file(filepath, data):
	var content = JSON.stringify(data, "    ", true)

	var file = FileAccess.open(filepath, FileAccess.WRITE)
	file.store_string(content)
	file.close()

func dir_list(dirpath, files=false):
	if self._dir_exists_os(dirpath):
		return self._dir_list_os(dirpath, files)
	elif self._dir_exists_project(dirpath):
		return self._dir_list(dirpath, files)
	return []

func _dir_list(dirpath, files=false):
	var listing = []
	var file_name
	
	var dir = DirAccess.open(dirpath)

	if dir != null:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir() and not files:
				listing.append(file_name)
			if not dir.current_is_dir() and files:
				listing.append(file_name)
			file_name = dir.get_next()
	else:
		print("Failed to open " + dirpath)

	return listing


func _dir_list_os(dirpath, files=false):
	var real_path = OS.get_executable_path().get_base_dir().path_join(dirpath)
	return self._dir_list(real_path, files)
