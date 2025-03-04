class_name TurnConfigView
extends Control


const TURN_STEP: int = 5
const TIME_STEP: int = 30


signal configuration_changed()


var turn_limit: int = 0
var time_limit: int = 0


func _ready() -> void:
	reset()


func reset() -> void:
	turn_limit = 0
	time_limit = 0
	update_values()


func update_values() -> void:
	if turn_limit > 0:
		$turn_limit_label/turn_limit_value.set_text(str(turn_limit))
	else:
		$turn_limit_label/turn_limit_value.set_text("TR_OFF")

	if time_limit > 0:
		$turn_time_label/turn_time_value.set_text(str(time_limit) + "s")
	else:
		$turn_time_label/turn_time_value.set_text("TR_OFF")


func set_turn_limit(new_limit: int) -> void:
	turn_limit = new_limit
	update_values()


func set_time_limit(new_limit: int) -> void:
	time_limit = new_limit
	update_values()



func _on_less_turn_button_pressed() -> void:
	turn_limit = maxi(0, turn_limit - TURN_STEP)
	update_values()
	configuration_changed.emit()


func _on_more_turn_button_pressed() -> void:
	turn_limit += TURN_STEP
	update_values()
	configuration_changed.emit()


func _on_less_time_button_pressed() -> void:
	time_limit = maxi(0, time_limit - TIME_STEP)
	update_values()
	configuration_changed.emit()


func _on_more_time_button_pressed() -> void:
	time_limit += TIME_STEP
	update_values()
	configuration_changed.emit()


func lock_buttons() -> void:
	$turn_limit_label/less_turn_button.hide()
	$turn_limit_label/more_turn_button.hide()
	$turn_time_label/less_time_button.hide()
	$turn_time_label/more_time_button.hide()


func unlock_buttons() -> void:
	$turn_limit_label/less_turn_button.show()
	$turn_limit_label/more_turn_button.show()
	$turn_time_label/less_time_button.show()
	$turn_time_label/more_time_button.show()
