extends Node

const AUTOSAVE_ID := 0
const LIST_FILE_PATH := "user://saves.json"
const SAVE_PATH := "user://save"
const SAVE_EXTENSION := ".tofsave.json"

var filesystem := FileSystem.new()

var autosave = [null, null, null]
var saves: Array[Dictionary] = []


func _ready():
	self.load_saves_from_file()


func add_new_save(map_name: String, map_label: String, turn_no: int, save_data: Dictionary) -> void:
	var new_save_id := self.saves.size() + 3
	self.saves.append({
		"map": map_name,
		"label": map_label,
		"turn": turn_no,
		"save_id": new_save_id,
		"created_at": Time.get_datetime_dict_from_system()
	})

	self.save_list_to_file()
	self.store_save_data(new_save_id, save_data)


func overwrite_save(map_name: String, map_label: String, turn_no: int, save_data: Dictionary, save_id: int) -> void:
	self.saves[save_id - 3] = {
		"map": map_name,
		"label": map_label,
		"turn": turn_no,
		"save_id": save_id,
		"created_at": Time.get_datetime_dict_from_system()
	}

	self.save_list_to_file()
	self.store_save_data(save_id, save_data)


func write_autosave(map_name: String, map_label: String, turn_no: int, save_data: Dictionary) -> void:
	self.autosave[2] = self.autosave[1]
	if self.autosave[2] != null:
		self.autosave[2]["save_id"] = 2
		_move_save_file(1, 2)
	self.autosave[1] = self.autosave[0]
	if self.autosave[1] != null:
		self.autosave[1]["save_id"] = 1
		_move_save_file(0, 1)
	self.autosave[0] = {
		"map": map_name,
		"label": map_label,
		"turn": turn_no,
		"save_id": 0,
		"created_at": Time.get_datetime_dict_from_system()
	}

	self.save_list_to_file()
	self.store_save_data(0, save_data)


func save_list_to_file() -> void:
	var save_data = {
		"autosave": self.autosave,
		"saves": self.saves
	}
	self.filesystem.write_data_as_json_to_file(self.LIST_FILE_PATH, save_data)


func load_saves_from_file() -> void:
	var save_data = self.filesystem.read_json_from_file(self.LIST_FILE_PATH)
	if save_data.has("saves"):
		self.saves = save_data["saves"]
	if save_data.has("autosave"):
		if save_data["autosave"] is Dictionary:
			save_data["autosave"] = [save_data["autosave"], null, null]
			self.autosave = save_data["autosave"]
			_migrate_saves()
			self.save_list_to_file()
		self.autosave = save_data["autosave"]


func get_entries_page(page_number: int, page_size: int) -> Array:
	var pages_count = self.get_pages_count(page_size)

	if page_number >= pages_count:
		return []

	var index_start := page_number * page_size
	var index_end := index_start + page_size

	var entries_list := []

	for autosave_entry in self.autosave:
		if autosave_entry != null:
			entries_list.append(autosave_entry)

	if self.saves.size() > 0:
		var saves_copy := self.saves.duplicate()
		saves_copy.reverse()
		entries_list += saves_copy

	var entries_count: int = entries_list.size()
	if index_end > entries_count:
		index_end = entries_count

	var index = index_start
	var output := []

	while index < index_end:
		output.append(entries_list[index])
		index += 1

	return output


func get_pages_count(page_size: int) -> int:
	var total_saves_count := self.saves.size()
	for autosave_entry in self.autosave:
		if autosave_entry != null:
			total_saves_count += 1

	var last_page_overflow := total_saves_count % page_size
	@warning_ignore("integer_division")
	var pages_count := (total_saves_count - last_page_overflow) / page_size

	if last_page_overflow > 0:
		pages_count += 1

	return pages_count


func get_save_data(save_id: int) -> Dictionary:
	var filepath := self.get_save_path(save_id)
	return self.filesystem.read_json_from_file(filepath)


func store_save_data(save_id: int, save_data: Dictionary) -> void:
	self.filesystem.write_data_as_json_to_file(self.get_save_path(save_id), save_data)


func get_save_path(save_id: int) -> String:
	return self.SAVE_PATH + str(save_id) + self.SAVE_EXTENSION


func compile_save_data(board) -> Dictionary:
	var map_name: String
	var map_label: String

	if board.match_setup.map_name != null:
		map_name = board.match_setup.map_name
		map_label = board.match_setup.map_name

	if board.match_setup.campaign_name != null:
		var manifest: Dictionary = board.campaign.get_campaign(board.match_setup.campaign_name)
		var mission_details: Dictionary = manifest["missions"][board.match_setup.mission_no]
		map_label = tr(manifest["title"]) + " - " + tr(mission_details["title"])

	var save_data := {
		"map_name": board.match_setup.map_name,
		"campaign_name": board.match_setup.campaign_name,
		"mission_no": board.match_setup.mission_no,
		"turn": board.state.turn,
		"active_player": board.state.current_player,
		"players": board.state.get_players_state_data(),
		"initial_setup": board.match_setup.stored_setup,
		"camera": board.map.camera.get_position_state(),
		"tiles": self._compile_tiles_data(board),
		"triggers": board.scripting.get_save_data(),
		"objectives": board.ui.objectives.raw_text,
		"player_moved": board.state.has_player_moved,
		"turn_limit": board.match_setup.turn_limit,
		"time_limit": board.match_setup.time_limit
	}

	return {
		"map_name": map_name,
		"map_label": map_label,
		"turn_no": board.state.turn,
		"save_data": save_data
	}

func _compile_tiles_data(board) -> Dictionary:
	var tiles_data := {}
	var tile

	for tile_key in board.map.model.tiles.keys():
		tile = board.map.model.tiles[tile_key]

		if tile.is_state_modified or tile.building.is_present() or tile.unit.is_present() or tile.damage.is_present():
			tiles_data[tile_key] = tile.get_dict()

	return tiles_data


func _move_save_file(source_id, destination_id) -> void:
	store_save_data(destination_id, get_save_data(source_id))


func _migrate_saves() -> void:
	var saves_copy := self.saves.duplicate()
	saves_copy.reverse()
	for save in saves_copy:
		_move_save_file(save["save_id"], int(save["save_id"] + 2))
		save["save_id"] = int(save["save_id"] + 2)
	saves_copy.reverse()
	self.saves = saves_copy
