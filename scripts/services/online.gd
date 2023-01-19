extends Node

onready var connector := OnlineConnector.new(self)
onready var player := OnlinePlayer.new(self)
onready var maps := OnlineMaps.new(self)


func _ready() -> void:
    self.player.load_data_from_file()


func is_integrated() -> bool:
    return self.player.is_registered()


func request_player_id() -> String:
    return self.player.request_player_id()


func upload_map(map_name: String) -> String:
    var content = MapManager.get_map_data(map_name)

    var response = self.maps.upload_map(content)

    if response is GDScriptFunctionState:
        response = yield(response, "completed")

    if response['status'] == 'ok':
        content["metadata"]["name"] = map_name
        content["metadata"]["base_code"] = response["data"]["base_code"]
        content["metadata"]["iteration"] = response["data"]["iteration"]
        MapManager.add_online_map_to_list(map_name, response["data"]["code"])
        MapManager.save_online_to_file(response["data"]["code"], content)
        MapManager.save_map_to_file(map_name, content)
        return response["data"]["code"]

    return ""
