extends Control

signal server_selected(address, port)

@onready var join_button = $"join"
@onready var name_label = $"name"
@onready var capacity_label = $"capacity"



var address = ""
var port = 0


func set_labels(server_name, capacity):
	self.name_label.set_text(server_name)
	self.capacity_label.set_text(capacity)


func _on_join_pressed():
	SimpleAudioLibrary.play("menu_click")
	self.server_selected.emit(self.address, self.port)
