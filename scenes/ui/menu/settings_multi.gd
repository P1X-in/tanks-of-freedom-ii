extends Control


func _ready():
	if OS.has_feature("demo"):
		$online_domain.hide()
		$online_port.hide()
		$relay_domain.hide()
		$relay_port.hide()

