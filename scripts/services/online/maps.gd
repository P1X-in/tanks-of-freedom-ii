extends Object
class_name OnlineMaps

var MAPS_URL: String = "/v2/maps"

var online_service


func _init(online) -> void:
    self.online_service = online


func upload_map(map_data: Dictionary) -> Dictionary:
    var message: Dictionary = self.online_service.player.get_basic_auth_json()
    var serialized_json = ""

    message['data'] = map_data
    serialized_json = JSON.print(message)

    var response = self.online_service.connector._post_request(self.MAPS_URL, serialized_json)

    if response is GDScriptFunctionState:
        response = yield(response, "completed")

    return response
