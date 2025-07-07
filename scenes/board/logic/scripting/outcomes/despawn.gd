extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var who = null
var fields = null

func _execute(_metadata):
	var tile
	if self.who != null:
		tile = self.board.map.model.get_tile(self.who)
		if tile.unit.is_present():
			if tile.unit.tile.unit_class == "hero":
				self.board.state.clear_hero_for_side(tile.unit.tile.side, tile.unit.tile)
			tile.unit.clear()
			self.board.smoke_a_tile(tile)
	elif self.fields != null:
		var x_index
		var y_index
		for rectangle in self.fields:
			x_index = rectangle["x1"]

			while x_index <= rectangle["x2"]:
				y_index = rectangle["y1"]
				while y_index <= rectangle["y2"]:
					tile = self.board.map.model.get_tile(Vector2i(x_index, y_index))
					if tile.unit.is_present():
						if tile.unit.tile.unit_class == "hero":
							self.board.state.clear_hero_for_side(tile.unit.tile.side, tile.unit.tile)
						tile.unit.clear()
						self.board.smoke_a_tile(tile)
					y_index += 1
				x_index += 1

func _ingest_details(details):
	if details.has("who"):
		self.who = Vector2i(details['who'][0], details['who'][1])
	if details.has("fields"):
		self.fields = details['fields']
