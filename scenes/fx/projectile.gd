extends Node3D

const ALTITUDE = 8

@onready var tween = $"tween"
@onready var tween2 = $"tween2"
@onready var tween3 = $"tween3"
@onready var mesh = $"pivot"

func shoot_at_position(destination_position, tween_time):
    self.look_at(destination_position, Vector3(0, 1, 0))

    var own_position = self.get_position()
    self.tween.interpolate_property(self, "position", own_position, destination_position, tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
    self.tween.start()
    await self.get_tree().create_timer(tween_time).timeout
    self.queue_free()

func lob_at_position(destination_position, tween_time):
    self.look_at(destination_position, Vector3(0, 1, 0))

    var own_position = self.get_position()
    self.tween.interpolate_property(self, "position", own_position, destination_position, tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
    self.tween.start()

    var mesh_translation = self.mesh.get_position()
    var peak_altitude = Vector3(0, self.ALTITUDE, 0)
    self.tween2.interpolate_property(mesh, "position", mesh_translation, peak_altitude, tween_time/2.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
    self.tween2.start()
    self.tween3.interpolate_property(mesh, "rotation_degrees", Vector3(270, 0, 0), Vector3(180, 0, 0), tween_time/2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    self.tween3.start()
    await self.get_tree().create_timer(tween_time/2.0).timeout
    self.tween2.interpolate_property(mesh, "position", peak_altitude, mesh_translation, tween_time/2.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
    self.tween2.start()
    self.tween3.interpolate_property(mesh, "rotation_degrees", Vector3(180, 0, 0), Vector3(90, 0, 0), tween_time/2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
    self.tween3.start()
    await self.get_tree().create_timer(tween_time/2.0).timeout

    self.queue_free()
