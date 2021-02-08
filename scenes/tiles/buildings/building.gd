extends "res://scenes/tiles/tile.gd"

onready var animations = $"animations"

export var side = "neutral"

export var require_crew = true

export var ap_gain = 5

var abilities = []

func get_dict():
    var new_dict = .get_dict()
    new_dict["side"] = self.side
    
    return new_dict

func set_side(new_side):
    self.side = new_side

func set_side_material(material):
    $"mesh".set_surface_material(0, material)

func register_ability(ability):
    self.abilities.append(ability)

func animate_coin():
    self.animations.play("ap_gain")

func sfx_effect(name):
    var audio_player = self.get_node_or_null("audio/" + name)
    if audio_player != null:
        audio_player.play()
   
