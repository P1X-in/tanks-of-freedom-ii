extends Node3D

const ALTITUDE = 8
@onready var mesh = $"pivot"

func shoot_at_position(destination_position, tween_time):
	self.look_at(destination_position, Vector3(0, 1, 0))

	create_tween().tween_property(self, "position", destination_position, tween_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	await self.get_tree().create_timer(tween_time).timeout
	self.queue_free()

func lob_at_position(destination_position, tween_time):
	self.look_at(destination_position, Vector3(0, 1, 0))

	create_tween().tween_property(self, "position", destination_position, tween_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)

	var mesh_translation = self.mesh.get_position()
	var peak_altitude = Vector3(0, self.ALTITUDE, 0)
	create_tween().tween_property(mesh, "position", peak_altitude, tween_time/2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	create_tween().tween_property(mesh, "rotation_degrees", Vector3(180, 0, 0), tween_time/2.0).from(Vector3(270, 0, 0)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)

	await self.get_tree().create_timer(tween_time/2.0).timeout

	create_tween().tween_property(mesh, "position", mesh_translation, tween_time/2.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

	create_tween().tween_property(mesh, "rotation_degrees", Vector3(90, 0, 0), tween_time/2.0).from(Vector3(180, 0, 0)).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)

	await self.get_tree().create_timer(tween_time/2.0).timeout

	self.queue_free()
