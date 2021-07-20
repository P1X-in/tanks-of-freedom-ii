extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

func _init():
    self.observed_event_type = ['ability_used']

func _observe(event):
    if not event.consumed:
        event.consumed = true
        self.execute_outcome(event)

func _get_outcome_metadata(event):
    return {
        'ability' : event.ability,
        'target' : event.target
    }
