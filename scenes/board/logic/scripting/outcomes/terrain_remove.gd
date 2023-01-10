extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var where
var explosion = false
var type

func _execute(_metadata):
    var tile = self.board.map.model.get_tile(self.where)

    if self.type == "decoration":
        tile.decoration.clear()
    elif self.type == "frame":
        tile.frame.clear()
    elif self.type == "terrain":
        tile.terrain.clear()
    elif self.type == "ground":
        tile.ground.clear()
    elif self.type == "building":
        tile.building.clear()

    if self.explosion:
        self.board.explode_a_tile(tile)
        self.board.audio.play("explosion")
    else:
        self.board.audio.play("menu_click")
    tile.is_state_modified = true

func _ingest_details(details):
    self.where = Vector2(details['where'][0], details['where'][1])
    self.type = details['type']
    if details.has('explosion'):
        self.explosion = details['explosion']
