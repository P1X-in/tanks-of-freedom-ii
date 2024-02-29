extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var who
var where
var path

func _execute(_metadata):
    var source_tile = self.board.map.model.get_tile(self.who)
    var destination_tile = self.board.map.model.get_tile(self.where)
    var unit = source_tile.unit.tile

    destination_tile.unit.set_tile(source_tile.unit.tile)
    source_tile.unit.release()

    unit.stop_animations()
    var world_position = self.board.map.map_to_local(source_tile.position)
    var old_position = unit.get_position()
    world_position.y = old_position.y
    unit.set_position(world_position)

    unit.bind_move_callback(self.board, "_reset_unit_position_array", [destination_tile, unit])
    unit.animate_path(self.path)

func _ingest_details(details):
    self.who = Vector2(details['who'][0], details['who'][1])
    self.where = Vector2(details['where'][0], details['where'][1])
    self.path = details['path']
