
var disk = preload("res://scenes/ui/icons/disk.tscn")
var back = preload("res://scenes/ui/icons/back.tscn")
var trash = preload("res://scenes/ui/icons/trash.tscn")
var tick = preload("res://scenes/ui/icons/tick.tscn")
var star = preload("res://scenes/ui/icons/star.tscn")

var deep_strike = preload("res://scenes/ui/icons/abilities/deep_strike.tscn")
var infiltration = preload("res://scenes/ui/icons/abilities/infiltration.tscn")
var targeting_automaton = preload("res://scenes/ui/icons/abilities/targeting_automaton.tscn")
var hardened_armour = preload("res://scenes/ui/icons/abilities/hardened_armour.tscn")
var precision_strike = preload("res://scenes/ui/icons/abilities/precision_strike.tscn")
var supply = preload("res://scenes/ui/icons/abilities/supply.tscn")
var inspire = preload("res://scenes/ui/icons/abilities/inspire.tscn")
var promote = preload("res://scenes/ui/icons/abilities/promote.tscn")

var heavy_weapon = preload("res://scenes/ui/icons/abilities/heavy_weapon.tscn")
var long_range_shell = preload("res://scenes/ui/icons/abilities/long_range_shell.tscn")
var pick_up = preload("res://scenes/ui/icons/abilities/pick_up.tscn")
var drop_off = preload("res://scenes/ui/icons/abilities/drop_off.tscn")
var medkit = preload("res://scenes/ui/icons/abilities/medkit.tscn")
var repair_kit = preload("res://scenes/ui/icons/abilities/repair_kit.tscn")
var missile = preload("res://scenes/ui/icons/abilities/missile.tscn")
var heavy_missile = preload("res://scenes/ui/icons/abilities/heavy_missile.tscn")
var rapid_response = preload("res://scenes/ui/icons/abilities/rapid_response.tscn")

var named_icons = {
    "disk" : self.disk,
    "back" : self.back,
    "trash" : self.trash,
    "tick" : self.tick,
    "star" : self.star,

    "deep_strike" : self.deep_strike,
    "infiltration" : self.infiltration,
    "targeting_automaton" : self.targeting_automaton,
    "hardened_armour" : self.hardened_armour,
    "precision_strike" : self.precision_strike,
    "supply" : self.supply,
    "inspire" : self.inspire,
    "promote" : self.promote,
    
    "heavy_weapon" : self.heavy_weapon,
    "long_range_shell" : self.long_range_shell,
    "pick_up" : self.pick_up,
    "drop_off" : self.drop_off,
    "medkit" : self.medkit,
    "repair_kit" : self.repair_kit,
    "missile" : self.missile,
    "heavy_missile" : self.heavy_missile,
    "rapid_response" : self.rapid_response,
}

func get_named_icon(name):
    return self.named_icons[name].instance()
