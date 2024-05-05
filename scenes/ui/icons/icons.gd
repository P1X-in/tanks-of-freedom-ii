
var disk = load("res://scenes/ui/icons/disk.tscn")
var quicksave = load("res://scenes/ui/icons/quicksave.tscn")
var back = load("res://scenes/ui/icons/back.tscn")
var quit = load("res://scenes/ui/icons/quit.tscn")
var trash = load("res://scenes/ui/icons/trash.tscn")
var tick = load("res://scenes/ui/icons/tick.tscn")
var star = load("res://scenes/ui/icons/star.tscn")
var star2 = load("res://scenes/ui/icons/star2.tscn")
var info = load("res://scenes/ui/icons/info.tscn")
var book = load("res://scenes/ui/icons/book.tscn")
var cross = load("res://scenes/ui/icons/cross.tscn")
var arrow_left = load("res://scenes/ui/icons/arrow_left.tscn")
var arrow_right = load("res://scenes/ui/icons/arrow_right.tscn")
var cog = load("res://scenes/ui/icons/cog.tscn")
var hourglass = load("res://scenes/ui/icons/hourglass.tscn")
var coin = load("res://scenes/ui/icons/coin.tscn")

var tof = load("res://scenes/ui/icons/tof.tscn")

var deep_strike = load("res://scenes/ui/icons/abilities/deep_strike.tscn")
var infiltration = load("res://scenes/ui/icons/abilities/infiltration.tscn")
var targeting_automaton = load("res://scenes/ui/icons/abilities/targeting_automaton.tscn")
var hardened_armour = load("res://scenes/ui/icons/abilities/hardened_armour.tscn")
var precision_strike = load("res://scenes/ui/icons/abilities/precision_strike.tscn")
var supply = load("res://scenes/ui/icons/abilities/supply.tscn")
var inspire = load("res://scenes/ui/icons/abilities/inspire.tscn")
var promote = load("res://scenes/ui/icons/abilities/promote.tscn")

var heavy_weapon = load("res://scenes/ui/icons/abilities/heavy_weapon.tscn")
var long_range_shell = load("res://scenes/ui/icons/abilities/long_range_shell.tscn")
var pick_up = load("res://scenes/ui/icons/abilities/pick_up.tscn")
var drop_off = load("res://scenes/ui/icons/abilities/drop_off.tscn")
var medkit = load("res://scenes/ui/icons/abilities/medkit.tscn")
var repair_kit = load("res://scenes/ui/icons/abilities/repair_kit.tscn")
var missile = load("res://scenes/ui/icons/abilities/missile.tscn")
var heavy_missile = load("res://scenes/ui/icons/abilities/heavy_missile.tscn")
var rapid_response = load("res://scenes/ui/icons/abilities/rapid_response.tscn")

var blue_gem = load("res://scenes/ui/icons/nations/blue.tscn")
var red_gem = load("res://scenes/ui/icons/nations/red.tscn")
var green_gem = load("res://scenes/ui/icons/nations/green.tscn")
var yellow_gem = load("res://scenes/ui/icons/nations/yellow.tscn")
var black_gem = load("res://scenes/ui/icons/nations/black.tscn")

var named_icons = {
    "disk" : self.disk,
    "quicksave" : self.quicksave,
    "back" : self.back,
    "quit" : self.quit,
    "trash" : self.trash,
    "tick" : self.tick,
    "star" : self.star,
    "star2" : self.star2,
    "info" : self.info,
    "book" : self.book,
    "cross" : self.cross,
    "arrow_left" : self.arrow_left,
    "arrow_right" : self.arrow_right,
    "cog" : self.cog,
    "hourglass" : self.hourglass,
    "coin" : self.coin,

    "tof" : self.tof,

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
        return self.named_icons[name].instantiate()
    return null
