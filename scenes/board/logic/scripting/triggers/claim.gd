extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

var amount = 1
var list = []
var player_id = null
var player_side = null

func _init():
    self.observed_event_type = ['building_captured']


func _observe(event):
    if self._is_watched_building(event.building):
        var side = event.new_side

        if self.player_id != null:
            side = self.board.state.get_player_side_by_id(self.player_id)
        if self.player_side != null:
            side = self.player_side

        if self._count_buildings_for_side(side) >= self.amount:
            self.execute_outcome(event)


func _get_outcome_metadata(event):
    return {
        'building' : event.building,
        'new_side' : event.new_side,
        'old_side' : event.old_side
    }


func ingest_details(details):
    self.list = details['list']
    if details.has('player'):
        self.player_id = details['player']
    if details.has('player_side'):
        self.player_side = details['player_side']
    if details.has('amount'):
        self.amount = details['amount']


func _is_watched_building(building):
    for position in self.list:
        if building == self.board.map.model.get_tile2(position[0], position[1]).building.tile:
            return true
    return false


func _count_buildings_for_side(side):
    var count = 0
    var building

    for position in self.list:
        building = self.board.map.model.get_tile2(position[0], position[1]).building.tile
        if building != null and building.side == side:
            count += 1

    return count
