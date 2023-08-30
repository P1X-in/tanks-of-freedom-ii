extends Node2D

@onready var animations = $"animations"

@export var zoom_value = 10

var model = null

func _ready():
    var lens_distance = Vector3(0, 0, self.zoom_value)
    $"SubViewport/tile_cam/pivot/arm/lens".set_position(lens_distance)
    self.refresh()

func refresh():
    var texture = $"SubViewport".get_texture()
    $"screen".texture = texture

func set_model(new_model):
    if self.model != null:
        self.clear()

    self.model = new_model
    $"SubViewport/tile_cam".add_child(new_model)

    self.refresh()

func clear():
    if self.model == null:
        return

    self.model.queue_free()
    self.model = null

func hide_background():
    $"background".hide()

func flash():
    self.animations.play("flash")

func stop_flash():
    self.animations.play("RESET")
