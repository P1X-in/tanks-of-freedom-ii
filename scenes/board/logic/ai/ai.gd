
var board
var collector

var _ai_paused = false
var _ai_abort = false

func _init(board_object):
    self.board = board_object
    self.collector = preload("res://scenes/board/logic/ai/collector.gd").new(board_object)

func run():
    self.call_deferred("_ai_tick")

func _finish_run():
    self.board.end_turn()

func _ai_tick():
    if self._ai_abort:
        return

    while self._ai_paused:
        yield(self.board.get_tree().create_timer(0.5), "timeout")

    var selected_action = self.collector.select_best_action()

    if selected_action != null:
        if self.board.map.move_camera_to_position_if_far_away(selected_action.target.position):
            yield(self.board.get_tree().create_timer(1), "timeout")
        var result = selected_action.perform(self.board)
        if result is GDScriptFunctionState: # Still working.
            result = yield(result, "completed")
        self.call_deferred("_ai_tick")
    else:
        if not self._ai_abort:
            self.call_deferred("_finish_run")

func abort():
    self._ai_abort = true
