
var board
var scripts

var triggers = {}
var trigger_groups = {}

var trigger_templates = preload("res://scenes/board/logic/scripting/triggers/templates.gd").new()
var outcome_templates = preload("res://scenes/board/logic/scripting/outcomes/templates.gd").new()

func ingest_scripts(board_object, incoming_scripts):
    self.board = board_object
    self.scripts = incoming_scripts

    if self.scripts == null or self.scripts.empty() or self.scripts['triggers'].empty():
        self._setup_basic_win_condition()
    else:
        for trigger_name in self.scripts['triggers']:
            self.triggers[trigger_name] = self._setup_trigger(self.scripts['triggers'][trigger_name])

func _setup_basic_win_condition():
    self._build_hq_lost_event(self.board.map.templates.MODERN_HQ)
    self._build_hq_lost_event(self.board.map.templates.STEAMPUNK_HQ)
    self._build_hq_lost_event(self.board.map.templates.FUTURISTIC_HQ)
    self._build_hq_lost_event(self.board.map.templates.FEUDAL_HQ)
    self.board.ui.objectives.set_objective_slot(0, "Capture enemy HQ")

func _build_hq_lost_event(hq_type):
    var trigger = self.trigger_templates.get_trigger('building_lost')
    var outcome = self.outcome_templates.get_outcome('eliminate_player')

    trigger.outcome = outcome
    trigger.building_type = hq_type

    outcome.board = self.board

    self.board.events.register_observer(self.board.events.types.BUILDING_CAPTURED, trigger, 'observe')

func _setup_trigger(trigger_definition):
    var new_trigger = self.trigger_templates.get_trigger(trigger_definition['type'])
    new_trigger.outcome = self._build_outcome_story(trigger_definition['story'])

    new_trigger.board = self.board
    new_trigger.ingest_details(trigger_definition['details'])

    if trigger_definition.has('one_off'):
        new_trigger.one_off = trigger_definition['one_off']

    for event_type in new_trigger.observed_event_type:
        self.board.events.register_observer(event_type, new_trigger, 'observe')

    return new_trigger

func _build_outcome_story(story_name):
    var story_definition = self.scripts['stories'][story_name]
    var new_story = self.outcome_templates.get_outcome('story')
    new_story.board = self.board

    for step in story_definition:
        new_story.add_step(self._build_outcome_story_step(step))

    return new_story

func _build_outcome_story_step(step_definition):
    var new_step = self.outcome_templates.get_outcome(step_definition['action'])
    new_step.board = self.board
    if step_definition.has('details'):
        new_step.ingest_details(step_definition['details'])
    if step_definition.has('delay'):
        new_step.delay = step_definition['delay']

    return new_step

func suspend_trigger(name, state):
    if self.triggers.has(name):
        self.triggers[name].suspended = state

func add_to_group(group_name, trigger_name):
    if not self.trigger_groups.has("group_name"):
        self.trigger_groups[group_name] = {}

    self.trigger_groups[group_name][trigger_name] = true

func remove_from_group(group_name, trigger_name):
    if not self.trigger_groups.has("group_name"):
        self.trigger_groups[group_name] = {}

    self.trigger_groups[group_name][trigger_name] = false

func suspend_group(group_name, state):
    if not self.trigger_groups.has("group_name"):
        return

    for trigger_name in self.trigger_groups[group_name].keys():
        if self.trigger_groups[group_name][trigger_name]:
            self.suspend_trigger(trigger_name, state)
