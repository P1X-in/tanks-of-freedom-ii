extends Node

const SFX_BUS = "SFX"
var samples = {}


func _ready():
    self.register_sample("menu_click", preload("res://assets/audio/menu.wav"))


func play(name):
    if not self.samples.has(name):
        return

    self.samples[name].play()


func register_sample(name, stream):
    if stream == null:
        return

    var sfx = AudioStreamPlayer.new()
    self.get_tree().get_root().call_deferred("add_child", sfx)
    sfx.set_stream(stream)
    sfx.set_bus(self.SFX_BUS)
    
    self.samples[name] = sfx

