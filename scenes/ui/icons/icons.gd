
var disk = preload("res://scenes/ui/icons/disk.tscn")
var quicksave = preload("res://scenes/ui/icons/quicksave.tscn")
var back = preload("res://scenes/ui/icons/back.tscn")
var quit = preload("res://scenes/ui/icons/quit.tscn")
var trash = preload("res://scenes/ui/icons/trash.tscn")
var tick = preload("res://scenes/ui/icons/tick.tscn")
var star = preload("res://scenes/ui/icons/star.tscn")
var info = preload("res://scenes/ui/icons/info.tscn")
var book = preload("res://scenes/ui/icons/book.tscn")
var cross = preload("res://scenes/ui/icons/cross.tscn")
var arrow_left = preload("res://scenes/ui/icons/arrow_left.tscn")
var arrow_right = preload("res://scenes/ui/icons/arrow_right.tscn")

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

var blue_gem = preload("res://scenes/ui/icons/nations/blue.tscn")
var red_gem = preload("res://scenes/ui/icons/nations/red.tscn")
var green_gem = preload("res://scenes/ui/icons/nations/green.tscn")
var yellow_gem = preload("res://scenes/ui/icons/nations/yellow.tscn")
var black_gem = preload("res://scenes/ui/icons/nations/black.tscn")

var named_icons = {
    "disk" : self.disk,
    "quicksave" : self.quicksave,
    "back" : self.back,
    "quit" : self.quit,
    "trash" : self.trash,
    "tick" : self.tick,
    "star" : self.star,
    "info" : self.info,
    "book" : self.book,
    "cross" : self.cross,
    "arrow_left" : self.arrow_left,
    "arrow_right" : self.arrow_right,

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

    "blue_gem" : self.blue_gem,
    "red_gem" : self.red_gem,
    "green_gem" : self.green_gem,
    "yellow_gem" : self.yellow_gem,
    "black_gem" : self.black_gem,
}

func get_named_icon(name):
    if self.named_icons.has(name):
        return self.named_icons[name].instance()
    return null
