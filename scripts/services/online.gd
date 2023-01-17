extends Node

const API_PORT = 443
const API_LOCATION = "api.tof.p1x.in"
const API_USE_SSL = true
const API_PRESENT_VERSION = "0.3.0"

var API_REGISTER_URL = "/players"

const ONLINE_FILE_PATH = "user://online.json"

var filesystem = preload("res://scripts/services/filesystem.gd").new()
var http_client = HTTPClient.new()

var integration_data = {
    "player_id": null,
    "pin": null,
}


func _ready():
    self.load_data_from_file()

func save_data_to_file():
    self.filesystem.write_data_as_json_to_file(self.ONLINE_FILE_PATH, self.integration_data)

func load_data_from_file():
    var loaded_data = self.filesystem.read_json_from_file(self.ONLINE_FILE_PATH)

    for key in loaded_data:
        self.integration_data[key] = loaded_data[key]

func is_integrated():
    return self.integration_data["player_id"] != null


func request_player_id():
    var response = self._post_request(self.API_REGISTER_URL)
    if response is GDScriptFunctionState:
        response = yield(response, "completed")

    if response['status'] == 'ok':
        self.integration_data["player_id"] = response['data']['id']
        self.integration_data["pin"] = response['data']['pin']
        self.save_data_to_file()

    return response['status']










func _get_request(resource, expect_json = true):
    return self._request(resource, HTTPClient.METHOD_GET, null, expect_json)

func _post_request(resource, data = null, expect_json = true):
    return self._request(resource, HTTPClient.METHOD_POST, data, expect_json)

func _request(resource, method, data, expect_json = true):
    var error
    var result = {
        'status' : null,
        'response_code' : 0,
        'data' : {}
    }

    error = self.http_client.connect_to_host(self.API_LOCATION, self.API_PORT, self.API_USE_SSL)

    if error != OK:
        result['status'] = 'error'
        result['message'] = 'Could not open connection'
        return result

    while self.http_client.get_status() == HTTPClient.STATUS_CONNECTING or self.http_client.get_status() == HTTPClient.STATUS_RESOLVING:
        self.http_client.poll()
        yield(self.get_tree().create_timer(0.1), "timeout")

    if self.http_client.get_status() != HTTPClient.STATUS_CONNECTED:
        result['status'] = 'error'
        result['message'] = 'Could not connect'
        return result

    var headers = [
        "User-Agent: ToF-II/" + self.API_PRESENT_VERSION,
        "Accept: */*"
    ]
    if data:
        headers.append("Content-Type: application/json")
        error = self.http_client.request(method, resource, headers, data)
    else:
        error = self.http_client.request(method, resource, headers)

    if error != OK:
        result['status'] = 'error'
        result['message'] = 'Could not make request'
        return result

    while self.http_client.get_status() == HTTPClient.STATUS_REQUESTING:
        self.http_client.poll()
        yield(self.get_tree().create_timer(0.1), "timeout")

    if self.http_client.get_status() != HTTPClient.STATUS_BODY and self.http_client.get_status() != HTTPClient.STATUS_CONNECTED:
        result['status'] = 'error'
        result['message'] = 'Could not poll request'
        return result

    if (self.http_client.has_response()):
        result['headers'] = self.http_client.get_response_headers_as_dictionary()
        result['response_code'] = self.http_client.get_response_code()

        var read_buffer = PoolByteArray()
        var chunk

        while self.http_client.get_status() == HTTPClient.STATUS_BODY:
            self.http_client.poll()
            chunk = self.http_client.read_response_body_chunk()
            if chunk.size() == 0:
                yield(self.get_tree().create_timer(0.1), "timeout")
            else:
                read_buffer = read_buffer + chunk

        var response_text = read_buffer.get_string_from_utf8()

        if expect_json:
            result['data'] = JSON.parse(response_text)
            if result['data'].error != OK:
                result['status'] = 'error'
                result['message'] = 'Could not poll request'
                return result
            else:
                result['data'] = result['data'].get_result()
        else:
            result['data'] = response_text

    if result['data'].has('error'):
        result['status'] = 'error'
        if OS.is_debug_build():
            print(result)
    else:
        result['status'] = 'ok'

    return result
