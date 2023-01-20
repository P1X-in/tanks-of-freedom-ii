extends Object
class_name OnlineMaps

var BROWSER_PAGE_SIZE: int = 20

var MAPS_URL: String = "/v2/maps"
var BROWSE_LISTING: String = "/listing"
var BROWSE_TOP: String = "/top/downloads"

var online_service
var listing_cache: Array = []
var listing_end: bool = false


func _init(online) -> void:
    self.online_service = online


func clear_cache() -> void:
    self.listing_cache = []
    self.listing_end = false


func fetch_listing_chunk(last_id: int) -> int:
    var resource: String = self.MAPS_URL + self.BROWSE_LISTING

    if last_id > 0:
        resource += "/" + str(last_id)

    var response = self.online_service.connector._get_request(resource, true)

    if response is GDScriptFunctionState:
        response = yield(response, "completed")

    if response['status'] != 'ok':
        return -1

    if response["data"]["maps"].size() < self.BROWSER_PAGE_SIZE:
        self.listing_end = true

    for map in response["data"]["maps"]:
        self.listing_cache.append(map)
    
    var last_element: Dictionary = self.listing_cache.back()
    return last_element["id"]


func fetch_top_downloads() -> int:
    self.clear_cache()
    var resource: String = self.MAPS_URL + self.BROWSE_TOP

    var response = self.online_service.connector._get_request(resource, true)
    if response is GDScriptFunctionState:
        response = yield(response, "completed")

    if response['status'] != 'ok':
        return -1

    self.listing_end = true
    for map in response["data"]["maps"]:
        self.listing_cache.append(map)
    
    if self.listing_cache.size() == 0:
        return -1

    var last_element: Dictionary = self.listing_cache.back()
    return last_element["id"]


func upload_map(map_data: Dictionary) -> Dictionary:
    var message: Dictionary = self.online_service.player.get_basic_auth_json()
    var serialized_json = ""

    message['data'] = map_data
    serialized_json = JSON.print(message)

    var response = self.online_service.connector._post_request(self.MAPS_URL, serialized_json)

    if response is GDScriptFunctionState:
        response = yield(response, "completed")

    return response


func download_map(code: String) -> Dictionary:
    var url: String = self.MAPS_URL + "/" + code + ".tofmap.json"
    var response = self.online_service.connector._get_request(url)

    if response is GDScriptFunctionState:
        response = yield(response, "completed")

    return response

