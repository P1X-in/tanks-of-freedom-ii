extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

var vip_id = null
var vip = null
var unit_type = null

func _init():
    self.observed_event_type = ['unit_destroyed']

func _observe(event):
    if event.unit_id == self.vip_id:
        self.vip = null
        self.execute_outcome(event)
    elif self.vip_id == null and event.unit_type == self.unit_type:
        self.execute_outcome(event)

func _get_outcome_metadata(event):
    return {
        'player_id' : self.board.state.get_player_id_by_side(event.unit_side),
        'side' : event.unit_side,
        'attacker' : event.attacker
    }

func set_vip(x, y):
    self.vip = self.board.map.model.get_tile2(x, y).unit.tile
    self.vip_id = self.vip.get_instance_id()

func ingest_details(details):
    if details.has("vip"):
        self.set_vip(details['vip'][0], details['vip'][1])
    if details.has("type"):
        self.unit_type = details["type"]

func get_save_data():
    var save_data = .get_save_data()
    save_data["vip"] = self.board.map.model.get_unit_position(self.vip)
    return save_data
