extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

var unit = null

func _init():
    self.observed_event_type = ['unit_attacked']

func _observe(event):
    if event.unit == self.unit:
        self.execute_outcome(event)

func _get_outcome_metadata(event):
    return {
        'unit' : event.unit,
        'attacker' : event.attacker
    }

func ingest_details(details):
    self.unit = self.board.map.model.get_tile2(details['vip'][0], details['vip'][1]).unit.tile
