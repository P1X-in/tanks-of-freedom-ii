class_name ConnectedPlayerPanel
extends NinePatchRect


signal kick_requested(peer_id: int)


var player_peer_id: int = 0


func bind_player(peer_id: int, player_info: Dictionary) -> void:
	player_peer_id = peer_id
	set_player_name(player_info["name"])
	if (Multiplayer.is_server() or Relay.is_server()) and player_peer_id > 1:
		show_kick_button()
	else:
		hide_kick_button()


func set_player_name(player_name: String) -> void:
	$label.set_text(player_name)


func show_kick_button() -> void:
	$kick_button.show()


func hide_kick_button() -> void:
	$kick_button.hide()


func _on_kick_button_pressed():
	kick_requested.emit(player_peer_id)
