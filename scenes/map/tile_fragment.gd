
var tile = null

func set_tile(new_tile):
    if self.tile != null:
        self.clear()

    self.tile = new_tile

func clear():
    if self.tile == null:
        return

    self.tile.queue_free()
    self.tile = null

func release():
    if self.tile != null:
        self.tile = null

func is_present():
    return self.tile != null

func get_dict():
    if self.tile == null:
        return {
            "tile" : null,
            "rotation" : 0,
        }
    else:
        return self.tile.get_dict()
