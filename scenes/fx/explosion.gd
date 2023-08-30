extends Node3D

@onready var main = $"main"
@onready var smoke = $"main/smoke"
@onready var small_main = $"small_main"
@onready var bless = $"bless"
@onready var heal = $"heal"

func grab_sfx_effect(unit):
    var audio_player = unit.give_sfx_effect("die")
    if audio_player == null:
        return

    audio_player.connect("finished", Callable(audio_player, "queue_free"))
    $"audio".add_child(audio_player)
    audio_player.play()

func explode():
    self.smoke.set_emitting(true)
    self.main.set_emitting(true)

func explode_a_bit():
    self.small_main.set_emitting(true)

func puff_some_smoke():
    self.smoke.set_emitting(true)

func rain_bless():
    self.bless.set_emitting(true)

func rain_heal():
    self.heal.set_emitting(true)
