extends Object
class_name OnlinePlayer

var API_REGISTER_URL := "/players"

const ONLINE_FILE_PATH := "user://online.json"

var filesystem := FileSystem.new()

var integration_data: Dictionary[String, Variant] = {
	"player_id": null,
	"pin": null,
	"integrations": {
		"api.tof.p1x.in": {
			"player_id": null,
			"pin": null,
		}
	}
}

var online_service = null


func _init(online):
	self.online_service = online


func save_data_to_file():
	self.filesystem.write_data_as_json_to_file(self.ONLINE_FILE_PATH, self.integration_data)


func load_data_from_file():
	var loaded_data = self.filesystem.read_json_from_file(self.ONLINE_FILE_PATH)

	for key in loaded_data:
		self.integration_data[key] = loaded_data[key]

	if self.integration_data["player_id"] != null and self.integration_data["integrations"]["api.tof.p1x.in"]["player_id"] == null:
		self.integration_data["integrations"]["api.tof.p1x.in"]["player_id"] = self.integration_data["player_id"]
		self.integration_data["integrations"]["api.tof.p1x.in"]["pin"] = self.integration_data["pin"]


func is_registered() -> bool:
	var current_integration = self.online_service.settings.get_option("online_domain")
	if not self.integration_data["integrations"].has(current_integration):
		return false
	return self.integration_data["integrations"][current_integration]["player_id"] != null


func request_player_id() -> Variant:
	var response = await self.online_service.connector._post_request(self.API_REGISTER_URL)

	if response['status'] == 'ok':
		var current_integration = self.online_service.settings.get_option("online_domain")
		if not self.integration_data["integrations"].has(current_integration):
			self.integration_data["integrations"][current_integration] = {
				"player_id": null,
				"pin": null,
			}
		self.integration_data["integrations"][current_integration]["player_id"] = response['data']['id']
		self.integration_data["integrations"][current_integration]["pin"] = response['data']['pin']
		self.save_data_to_file()

	return response['status']


func get_basic_auth_json() -> Dictionary[String, Variant]:
	var current_integration = self.online_service.settings.get_option("online_domain")
	if not self.integration_data["integrations"].has(current_integration):
		return {}
	return {
		'player_id' : self.integration_data["integrations"][current_integration]["player_id"],
		'player_pin' : self.integration_data["integrations"][current_integration]["pin"]
	}
