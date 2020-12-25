extends Spatial

onready var main = $"main"
onready var smoke = $"main/smoke"
onready var small_main = $"small_main"

func explode():
    self.smoke.set_emitting(true)
    self.main.set_emitting(true)

func explode_a_bit():
    self.small_main.set_emitting(true)

func puff_some_smoke():
    self.smoke.set_emitting(true)
