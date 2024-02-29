extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var where
var template_name = null
var side
var rotation = 0
var sound = true
var promote = false

func _execute(_metadata):
	var tile = self.board.map.model.get_tile(self.where)
	tile.unit.clear()

	var new_unit = self.board.map.builder.force_place_unit(self.where, self.template_name, self.rotation, self.side)
	new_unit.team = self.board.state.get_player_team(self.side)
	new_unit.replenish_moves()

	if self.sound:
		new_unit.sfx_effect("spawn")

	if self.promote:
		new_unit.level_up()

func _ingest_details(details):
	self.where = Vector2(details['where'][0], details['where'][1])
	self.template_name = details['template']
	self.side = details['side']
	if details.has('rotation'):
		self.rotation = details['rotation']
	if details.has('sound'):
		self.sound = details['sound']
	if details.has('promote'):
		self.promote = details['promote']
