
var board
var scripts

var trigger_templates = {
    'building_lost' : preload("res://scenes/board/logic/scripting/triggers/building_lost.gd")
}

var outcome_templates = {
    'end_game' : preload("res://scenes/board/logic/scripting/outcomes/end_game.gd"),
    'eliminate_player' : preload("res://scenes/board/logic/scripting/outcomes/eliminate_player.gd")
}

func ingest_scripts(board_object, incoming_scripts):
    self.board = board_object
    self.scripts = incoming_scripts

    if self.scripts == null or self.scripts.empty():
        self._setup_basic_win_condition()

func _setup_basic_win_condition():
    self._build_hq_lost_event(self.board.map.templates.MODERN_HQ)
    self._build_hq_lost_event(self.board.map.templates.STEAMPUNK_HQ)

func _build_hq_lost_event(hq_type):
    var trigger = self.trigger_templates['building_lost'].new()
    var outcome = self.outcome_templates['eliminate_player'].new()

    trigger.outcome = outcome
    trigger.building_type = hq_type

    outcome.board = self.board

    self.board.events.register_observer(self.board.events.types.BUILDING_CAPTURED, trigger, 'observe')
    