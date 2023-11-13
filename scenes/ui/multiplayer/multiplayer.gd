extends "res://scenes/ui/menu/base_menu_panel.gd"

@onready var main_panel = $"widgets/main"
@onready var address_panel = $"widgets/address"
@onready var nickname_input = $"widgets/main/nickname"

@onready var back_button = $"widgets/back_button"
@onready var connect_button = $"widgets/address/connect_button"
@onready var connect_input = $"widgets/address/address"
@onready var connect_port = $"widgets/address/port"
@onready var connect_message = $"widgets/address/message"

@onready var settings = $"/root/Settings"
@onready var multiplayer_srv = $"/root/Multiplayer"

var connection_busy = false

func _ready():
	super._ready()
	self.nickname_input.set_text(self.settings.get_option("nickname"))
	self.connect_input.set_text(self.settings.get_option("last_used_ip"))
	self.connect_port.set_text(self.settings.get_option("last_used_port"))

	self.multiplayer_srv.connection_failed.connect(_on_connection_failed)
	self.multiplayer_srv.connection_success.connect(_on_connection_success)
	
func _on_back_button_pressed():
	super._on_back_button_pressed()

	if self.connection_busy:
		return
	
	if self.address_panel.is_visible():
		_switch_to_main_panel()
	else:
		self.main_menu.close_multiplayer()

func _switch_to_main_panel():
	self.address_panel.hide()
	self.main_panel.show()

func _switch_to_connect_panel():
	self.connect_message.set_text("")
	self.main_panel.hide()
	self.address_panel.show()

func _on_create_button_pressed():
	self.audio.play("menu_click")
	self.main_menu.open_multiplayer_picker()


func _on_join_button_pressed():
	self.audio.play("menu_click")
	_switch_to_connect_panel()


func _on_nickname_focus_exited():
	self.settings.set_option("nickname", self.nickname_input.get_text())

func _on_address_focus_exited():
	self.settings.set_option("last_used_ip", self.connect_input.get_text())

func _on_port_focus_exited():
	self.settings.set_option("last_used_port", self.connect_port.get_text())


func _on_connect_button_pressed():
	self.audio.play("menu_click")
	_connect_to_server(self.connect_input.get_text(), self.connect_port.get_text().to_int())

func _connect_to_server(address, port):
	if self.connection_busy:
		return

	self.connection_busy = true
	self.connect_message.set_text(tr("TR_CONNECTING"))
	var error = self.multiplayer_srv.connect_server(address, port)
	if error:
		self.connection_busy = false
		self.connect_message.set_text(tr("TR_CONNECTION_ERROR"))


func _on_connection_success():
	self.connection_busy = false
	_switch_to_main_panel()
	self.main_menu.open_multiplayer_lobby()

func _on_connection_failed():
	self.connection_busy = false
	self.connect_message.set_text(tr("TR_CONNECTION_ERROR"))
