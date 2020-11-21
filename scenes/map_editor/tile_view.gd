extends Node2D

export var viewport_size = 20

export var is_side_tile = false

var tile = null

func _ready():
    $"Viewport/tile_cam/pivot/arm/lens".set_size(self.viewport_size)
    self.refresh()

func refresh():
    var texture = $"Viewport".get_texture()
    $"screen".texture = texture

func set_tile(new_tile, rotation):
    if self.tile != null:
        self.clear()

    self.tile = new_tile
    $"Viewport/tile_cam".add_child(new_tile)

    var tile_rotation = Vector3(0, deg2rad(rotation), 0)
    new_tile.set_rotation(tile_rotation)
    new_tile.reset_position_for_tile_view()

    if self.is_side_tile:
        $"Viewport/tile_cam/pivot/arm/lens".set_size(self.viewport_size + new_tile.side_tile_view_cam_modifier)
    else:
        $"Viewport/tile_cam/pivot/arm/lens".set_size(self.viewport_size + new_tile.main_tile_view_cam_modifier)

    self.refresh()

func clear():
    if self.tile == null:
        return

    self.tile.queue_free()
    self.tile = null
