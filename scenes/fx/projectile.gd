extends Spatial

onready var tween = $"tween"

func shoot_at_position(destination_position, tween_time):
    self.look_at(destination_position, Vector3(0, 1, 0))

    var own_position = self.get_translation()
    self.tween.interpolate_property(self, "translation", own_position, destination_position, tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
    self.tween.start()
    yield(self.get_tree().create_timer(tween_time), "timeout")
    self.queue_free()
