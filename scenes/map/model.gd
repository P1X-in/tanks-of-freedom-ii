
const SIZE = 40

var tile_template = preload("res://scenes/map/tile.gd")

var tiles = {}

func _init():
    for x in range(self.SIZE):
        for y in range(self.SIZE):
            self.tiles[str(x) + "_" + str(y)] = self.tile_template.new(x, y)

func get_tile(position):
    return self.tiles[str(position.x) + "_" + str(position.y)]

func get_tile2(x, y):
    return self.tiles[str(x) + "_" + str(y)]

func get_dict():
    var tiles_dict = {}
    for i in self.tiles.keys():
        if self.tiles[i].has_content():
          tiles_dict[i] = self.tiles[i].get_dict()

    return {
        "metadata" : {},
        "tiles" : tiles_dict,
    }
