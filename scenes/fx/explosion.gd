extends Spatial

onready var main = $"main"
onready var smoke = $"main/smoke"

func explode():
    self.smoke.set_emitting(true)
    self.main.set_emitting(true)
    
