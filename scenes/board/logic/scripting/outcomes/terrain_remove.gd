extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var where
var explosion = false
var type

func _execute(_metadata):
    var tile = self.board.map.model.get_tile(self.where)
    var position

    if self.type == "decoration":
        tile.decoration.clear()
    elif self.type == "frame":
        tile.frame.clear()
    elif self.type == "terrain":
        tile.terrain.clear()

    if self.explosion:
        position = tile.ground.tile.get_translation()
        self.board.explosion.set_translation(Vector3(position.x, 0, position.z))
        self.board.explosion.explode()
        self.board.audio.play("explosion")
    else:
        self.board.audio.play("menu_click")

func _ingest_details(details):
    self.where = Vector2(details['where'][0], details['where'][1])
    self.type = details['type']
    if details.has('explosion'):
        self.explosion = details['explosion']
