class_name TurnTimeView
extends Control


signal turn_timeout()


var _turn_time: int = 0
var _accumulated_time: float = 0.0


func start_timer(seconds: int) -> void:
	_turn_time = seconds
	_accumulated_time = 0.0


func reset() -> void:
	_turn_time = 0
	_accumulated_time = 0.0


func _update_time() -> void:
	var time_diff: int = maxi(0, roundi(_turn_time - _accumulated_time))
	$label.set_text(str(time_diff))


func _physics_process(delta: float) -> void:
	if _turn_time > 0:
		_accumulated_time += delta
		_update_time()
		if _accumulated_time >= _turn_time:
			_turn_time = 0
			_accumulated_time = 0.0
			turn_timeout.emit()
