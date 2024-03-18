extends Node3D
class_name Explosion

@onready var main: GPUParticles3D = $"main"
@onready var smoke: GPUParticles3D = $"main/smoke"
@onready var small_main: GPUParticles3D = $"small_main"
@onready var bless: GPUParticles3D = $"bless"
@onready var heal: GPUParticles3D = $"heal"

func grab_sfx_effect(unit: BaseUnit) -> void:
	var audio_player: AudioStreamPlayer = unit.give_sfx_effect("die")
	if audio_player == null:
		return

	audio_player.connect("finished", Callable(audio_player, "queue_free"))
	$"audio".add_child(audio_player)
	audio_player.play()

func explode() -> void:
	self.smoke.set_emitting(true)
	self.main.set_emitting(true)

func explode_a_bit() -> void:
	self.small_main.set_emitting(true)

func puff_some_smoke() -> void:
	self.smoke.set_emitting(true)

func rain_bless() -> void:
	self.bless.set_emitting(true)

func rain_heal() -> void:
	self.heal.set_emitting(true)
