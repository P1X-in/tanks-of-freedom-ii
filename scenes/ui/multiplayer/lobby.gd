extends "res://scenes/ui/menu/base_menu_panel.gd"

@onready var multiplayer_srv = $"/root/Multiplayer"

func _ready():
    super._ready()
    self.multiplayer_srv.player_connected.connect(_on_player_connected)
    self.multiplayer_srv.player_disconnected.connect(_on_player_disconnected)
    self.multiplayer_srv.server_disconnected.connect(_on_server_disconnected)
    
func _on_back_button_pressed():
    super._on_back_button_pressed()
    
    self.multiplayer_srv.close_game()
    self.main_menu.close_multiplayer_lobby()

func _on_player_connected(peer_id, player_info):
    print(peer_id)
    print(player_info)

func _on_player_disconnected(peer_id):
    print(peer_id)

func _on_server_disconnected():
    print("server gone")
