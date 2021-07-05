
const PLAYER_HUMAN = "human"
const PLAYER_AI = "ai"


var current_player = 0
var turn = 1

var players = []
var suspended = false


func add_player(type, side):
    self.players.append({
        "type": type,
        "side": side,
        "ap" : 0,
        "alive" : true,
        "hero" : null
    })


func switch_to_next_player():
    self.current_player += 1
    if self.current_player >= self.players.size():
        self.current_player = 0
        self.turn += 1

    if not self.is_current_player_alive():
        self.switch_to_next_player()

func get_current_player():
    return self.players[self.current_player]

func get_current_ap():
    return self.get_current_param("ap")

func get_current_side():
    return self.get_current_param("side")

func get_current_hero():
    return self.get_current_param("hero")

func get_player_id_by_side(side):
    var index = 0

    while index < self.players.size():
        if self.players[index]['side'] == side:
            return index
        index += 1

func get_player_side_by_id(id):
    return self.players[id]['side']

func get_current_param(param_name):
    var player_data = self.get_current_player()
    return player_data[param_name]

func add_player_ap(id, value):
    self.players[id]["ap"] += value

    if self.players[id]["ap"] < 0:
        self.players[id]["ap"] = 0

func use_player_ap(id, value):
    self.players[id]["ap"] -= value

    if self.players[id]["ap"] < 0:
        self.players[id]["ap"] = 0

func get_player_ap(id):
    return self.players[id]["ap"]

func use_current_player_ap(value):
    self.use_player_ap(self.current_player, value)

func add_current_player_ap(value):
    self.add_player_ap(self.current_player, value)

func can_current_player_afford(amount):
    return self.get_current_ap() >= amount

func is_current_player_ai():
    return self.get_current_param("type") == self.PLAYER_AI

func is_current_player_alive():
    return self.get_current_param("alive")

func eliminate_player(side):
    var index = 0

    while index < self.players.size():
        if self.players[index]['side'] == side:
            self.players[index]['alive'] = false
            return
        index += 1

func count_alive_players():
    var amount = 0

    for player in self.players:
        if player["alive"]:
            amount += 1

    return amount

func has_current_player_a_hero():
    return self.get_current_hero() != null

func has_side_a_hero(side):
    return self.players[self.get_player_id_by_side(side)]['hero'] != null

func set_hero_for_player(id, hero):
    self.players[id]["hero"] = hero

func set_hero_for_side(side, hero):
    self.set_hero_for_player(self.get_player_id_by_side(side), hero)

func auto_set_hero(hero):
    self.set_hero_for_side(hero.side, hero)

func set_current_hero(hero):
    self.set_hero_for_player(self.current_player, hero)

func clear_hero_for_player(id):
    self.set_hero_for_player(id, null)

func clear_current_hero():
    self.clear_hero_for_player(self.current_player)

func clear_hero_for_side(side):
    self.clear_hero_for_player(self.get_player_id_by_side(side))

func register_heroes(model):
    var index = 0

    while index < self.players.size():
        self.players[index]['hero'] = model.get_player_hero(self.players[index]['side'])
        index += 1

func track_hero_spawn(event):
    if event.unit.unit_class != "hero":
        return

    self.auto_set_hero(event.unit)
