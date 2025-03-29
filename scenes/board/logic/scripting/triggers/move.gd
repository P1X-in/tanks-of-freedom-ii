extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

var fields = []
var player_id = null
var player_side = null
var unit_tag = null
var excluded = []
var exclude_tags = []

func _init():
	self.observed_event_type = ['unit_moved']

func _observe(event):
	if self._is_watched_tile(event.finish):
		if self.is_excluded_vip(event.unit):
			return

		if self.player_id != null:
			if self.player_id == self.board.state.get_player_id_by_side(event.unit.side):
				self.execute_outcome(event)
		elif self.player_side != null:
			if self.player_side == event.unit.side:
				self.execute_outcome(event)
		elif self.unit_tag != null:
			if event.unit.has_script_tag(self.unit_tag):
				self.execute_outcome(event)
		else:
			self.execute_outcome(event)


func execute_outcome(event):
	super.execute_outcome(event)
	self.board.set_last_unit_move(null)

func _get_outcome_metadata(event):
	return {
		'field' : event.finish,
		'player_id' : self.board.state.get_player_id_by_side(event.unit.side),
		'side' : event.unit.side,
		'unit' : event.unit
	}

func set_vip(x, y):
	self.unit_tag = "move_" + str(x) + "_" + str(y)
	self.board.map.model.get_tile2(x, y).unit.tile.add_script_tag(self.unit_tag)

func exclude_vip(x, y):
	var new_tag = "exclude_move_" + str(x) + "_" + str(y)
	self.exclude_tags.append(new_tag)
	self.board.map.model.get_tile2(x, y).unit.tile.add_script_tag(new_tag)

func is_excluded_vip(unit):
	if self.exclude_tags.size() < 1:
		return false

	for excluded_tag in self.exclude_tags:
		if unit.has_script_tag(excluded_tag):
			return true

	return false

func ingest_details(details):
	self.fields = details['fields']
	if details.has('player'):
		self.player_id = details['player']
	if details.has('player_side'):
		self.player_side = details['player_side']
	if details.has('unit'):
		self.set_vip(details['unit'][0], details['unit'][1])
	if details.has('unit_tag'):
		self.unit_tag = details['unit_tag']
	if details.has('excluded'):
		for unit in details['excluded']:
			self.exclude_vip(unit[0], unit[1])

func _is_watched_tile(tile):
	for rectangle in self.fields:
		if tile.position.x >= rectangle["x1"] and tile.position.x <= rectangle["x2"] and tile.position.y >= rectangle["y1"] and tile.position.y <= rectangle["y2"]:
			return true
	return false
