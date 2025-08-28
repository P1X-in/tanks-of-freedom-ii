class_name MultiplayerSettingsCategoryPanel
extends SettingsCategoryPanel


@onready var audio = $"/root/SimpleAudioLibrary"
@onready var settings = $"/root/Settings"


var defaults: Dictionary = {
	"game_port": 3959,
	"discovery_port": 3960,
	"online_domain": "api.tof.p1x.in",
	"online_port": 443,
	"relay_domain": "api.tof.p1x.in",
	"relay_port": 9959,
}


func _ready() -> void:
	super._ready()
	if OS.has_feature("demo"):
		$VBoxContainer/online_domain.hide()
		$VBoxContainer/online_port.hide()
		$VBoxContainer/relay_domain.hide()
		$VBoxContainer/relay_port.hide()


func _on_reset_button_pressed() -> void:
	for setting_key: String in self.defaults:
		self.settings.set_option(setting_key, self.defaults[setting_key])

	self.audio.play("menu_click")
	$VBoxContainer/game_port._read_setting()
	$VBoxContainer/discovery_port._read_setting()
	$VBoxContainer/online_domain._read_setting()
	$VBoxContainer/online_port._read_setting()
	$VBoxContainer/relay_domain._read_setting()
	$VBoxContainer/relay_port._read_setting()
