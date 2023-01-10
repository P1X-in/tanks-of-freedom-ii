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


func set_vip(x, y):
    self.unit = self.board.map.model.get_tile2(x, y).unit.tile

func ingest_details(details):
    self.set_vip(details['vip'][0], details['vip'][1])

func get_save_data():
    var save_data = .get_save_data()
    save_data["unit"] = self.board.map.model.get_unit_position(self.vip)
    return save_data
