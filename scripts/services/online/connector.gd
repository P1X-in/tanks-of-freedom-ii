extends Object
class_name OnlineConnector

const API_PORT: int = 443
const API_LOCATION: String = "api.tof.p1x.in"
const API_USE_SSL: bool = true
const API_PRESENT_VERSION: String = "0.3.0"

var http_client: HTTPClient = HTTPClient.new()
var online_service = null

func _init(online) -> void:
    self.online_service = online

func _get_request(resource: String, expect_json: bool = true) -> Dictionary:
    return self._request(resource, HTTPClient.METHOD_GET, "", expect_json)

func _post_request(resource: String, data: String = "", expect_json: bool = true) -> Dictionary:
    return self._request(resource, HTTPClient.METHOD_POST, data, expect_json)

func _request(resource: String, method, data: String, expect_json: bool = true) -> Dictionary:
    var error
    var result := {
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
        error = self.http_client.poll()
        yield(self.online_service.get_tree().create_timer(0.1), "timeout")

    if self.http_client.get_status() != HTTPClient.STATUS_CONNECTED:
        result['status'] = 'error'
        result['message'] = 'Could not connect'
        return result

    var headers := [
        "User-Agent: ToF-II/" + self.API_PRESENT_VERSION,
        "Accept: */*"
    ]
    if data != "":
        headers.append("Content-Type: application/json")
        error = self.http_client.request(method, resource, headers, data)
    else:
        error = self.http_client.request(method, resource, headers)

    if error != OK:
        result['status'] = 'error'
        result['message'] = 'Could not make request'
        return result

    while self.http_client.get_status() == HTTPClient.STATUS_REQUESTING:
        error = self.http_client.poll()
        yield(self.online_service.get_tree().create_timer(0.1), "timeout")

    if self.http_client.get_status() != HTTPClient.STATUS_BODY and self.http_client.get_status() != HTTPClient.STATUS_CONNECTED:
        result['status'] = 'error'
        result['message'] = 'Could not poll request'
        return result

    if (self.http_client.has_response()):
        result['headers'] = self.http_client.get_response_headers_as_dictionary()
        result['response_code'] = self.http_client.get_response_code()

        var read_buffer := PoolByteArray()
        var chunk

        while self.http_client.get_status() == HTTPClient.STATUS_BODY:
            error = self.http_client.poll()
            chunk = self.http_client.read_response_body_chunk()
            if chunk.size() == 0:
                yield(self.online_service.get_tree().create_timer(0.1), "timeout")
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
