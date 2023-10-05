
var board
var collector

var _ai_paused = false
var _ai_abort = false

const FAILSAFE = 4
var _failsafe_counter = 0
var _last_action_signature = null

var _reserved_ap = 0

func _init(board_object):
	self.board = board_object
	self.collector = preload("res://scenes/board/logic/ai/collector.gd").new(board_object)

func run():
	self._failsafe_counter = 0
	self._reserved_ap = 0
	self.call_deferred("_ai_tick")

func reserve_ap(amount):
	self._reserved_ap += amount

func _finish_run():
	self.board.end_turn()

func _ai_tick():
	if self._ai_abort:
		return

	while self._ai_paused or self.board.map.camera.camera_in_transit or self.board.map.camera.script_operated:
		var timer = self.board.get_tree().create_timer(0.1)
		timer.connect("timeout", Callable(self, "_ai_tick"))
		return

	if self._ai_abort:
		return

	var selected_action = await self.collector.select_best_action()

	await self.board.get_tree().create_timer(0.1).timeout

	if selected_action != null and self._failsafe_counter < self.FAILSAFE:
		if selected_action.target != null and self.board.map.move_camera_to_position_if_far_away(selected_action.target.position):
			await self.board.get_tree().create_timer(1).timeout
			if self._ai_abort:
				return
			if self._ai_paused:
				self.call_deferred("_ai_tick")
				return

		if self._failsafe_counter > 0:
			self.board.map.camera.camera_in_transit = false
		await selected_action.perform(self.board)

		if str(selected_action) == self._last_action_signature:
			self._failsafe_counter += 1
		else:
			self._failsafe_counter = 0
		self._last_action_signature = str(selected_action)

		self.call_deferred("_ai_tick")
	else:
		if self._failsafe_counter >= self.FAILSAFE:
			print("AI failsafe")
			print(selected_action)

		if not self._ai_abort:
			self.call_deferred("_finish_run")

func abort():
	self._ai_abort = true
