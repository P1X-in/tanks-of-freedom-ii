extends Node

const SCAN_TIME: int = 5

signal scanned_server

@onready var settings: Node = $"/root/Settings"
@onready var multiplayer_srv = $"/root/Multiplayer"

var client: PacketPeerUDP
var server: UDPServer

var scanned_servers := []

var is_scanning := false
var is_servering := false

func scan_lan_servers() -> void:
	self.scanned_servers = []

	self.client = PacketPeerUDP.new()
	self.client.set_broadcast_enabled(true)
	self.client.set_dest_address("255.255.255.255", self.settings.get_option("discovery_port"))
	self.client.put_var({'type':'get_server'})
	self.get_tree().create_timer(self.SCAN_TIME).timeout.connect(abort_lan_scan)

	self.is_scanning = true

func start_autodiscovery_server() -> void:
	self.server = UDPServer.new()
	self.server.listen(self.settings.get_option("discovery_port"),'0.0.0.0')
	self.is_servering = true

func stop_autodiscovery_server() -> void:
	if self.server != null:
		self.server.stop()
	self.server = null
	self.is_servering = false

func _process(_delta) -> void:
	if self.is_scanning:
		if self.client.get_available_packet_count() > 0:
			var data = self.client.get_packet().decode_var(0)
			var server_ip = self.client.get_packet_ip()
			data['server_ip'] = server_ip
			self.scanned_servers.append(data)
			scanned_server.emit()

	if self.is_servering:
		self.server.poll()
		if self.server.is_connection_available():
			var peer: PacketPeerUDP = self.server.take_connection()
			if peer.get_packet().decode_var(0)['type'] == 'get_server':
				peer.put_var({
					"port": self.settings.get_option("game_port"),
					"map": self.multiplayer_srv.selected_map,
					"players": str(self.multiplayer_srv.players.size()) + "/" + str(self.multiplayer_srv.player_limit + 1),
					"joinable": self.multiplayer_srv.players.size() < self.multiplayer_srv.player_limit + 1
				})

func abort_lan_scan() -> void:
	self.is_scanning = false
	if self.client != null:
		self.client.close()
	self.client = null
