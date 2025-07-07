extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var where
var zoom = null

func _init():
	self.delay = 1

func _execute(_metadata):
	self.board.map.move_camera_to_position_if_far_away(self.where, 0, self.zoom)

func _ingest_details(details):
	self.where = Vector2i(details['where'][0], details['where'][1])
	if details.has('zoom'):
		self.zoom = details['zoom']
