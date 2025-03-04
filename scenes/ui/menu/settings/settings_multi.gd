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
		$online_domain.hide()
		$online_port.hide()
		$relay_domain.hide()
		$relay_port.hide()


func _on_reset_button_pressed() -> void:
	for setting_key: String in self.defaults:
		self.settings.set_option(setting_key, self.defaults[setting_key])

	self.audio.play("menu_click")
	$game_port._read_setting()
	$discovery_port._read_setting()
	$online_domain._read_setting()
	$online_port._read_setting()
	$relay_domain._read_setting()
	$relay_port._read_setting()


