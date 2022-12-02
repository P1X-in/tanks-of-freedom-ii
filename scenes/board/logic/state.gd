
const PLAYER_HUMAN = "human"
const PLAYER_AI = "ai"


var current_player = 0
var turn = 1

var players = []


func add_player(type, side):
    self.players.append({
        "type": type,
        "side": side,
        "ap" : 0,
        "alive" : true,
        "heroes" : {}
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

func get_current_heroes():
    return self.get_current_param("heroes")

func get_player_id_by_side(side):
    var index = 0

    while index < self.players.size():
        if self.players[index]['side'] == side:
            return index
        index += 1

    return null

func get_player_side_by_id(id):
    return self.players[id]['side']

func get_current_param(param_name):
    var player_data = self.get_current_player()
    return player_data[param_name]

func set_player_ap(id, value):
    self.players[id]["ap"] = value

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

func is_player_human(side):
    return self.players[self.get_player_id_by_side(side)]["type"] == self.PLAYER_HUMAN

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
    return self.get_current_heroes().size() > 0

func has_side_a_hero(side):
    return self.players[self.get_player_id_by_side(side)]['heroes'].size() > 0

func add_hero_for_player(id, hero):
    self.players[id]["heroes"][hero.get_instance_id()] = hero

func get_heroes_for_player(id):
    return self.players[id]["heroes"].values()

func add_hero_for_side(side, hero):
    self.add_hero_for_player(self.get_player_id_by_side(side), hero)

func get_heroes_for_side(side):
    var side_id = self.get_player_id_by_side(side)
    if side_id == null:
        return null
    return self.get_heroes_for_player(side_id)

func auto_set_hero(hero):
    self.add_hero_for_side(hero.side, hero)

func add_current_hero(hero):
    self.add_hero_for_player(self.current_player, hero)

func clear_hero_for_player(id, hero):
    if id == null or hero == null:
        return

    self.players[id]["heroes"].erase(hero.get_instance_id())

func clear_current_hero(hero):
    self.clear_hero_for_player(self.current_player, hero)

func clear_hero_for_side(side, hero):
    self.clear_hero_for_player(self.get_player_id_by_side(side), hero)

func register_heroes(model):
    var index = 0
    var heroes = []

    while index < self.players.size():
        heroes = model.get_player_heroes(self.players[index]['side'])
        for hero in heroes:
            self.add_hero_for_player(index, hero)
        index += 1
