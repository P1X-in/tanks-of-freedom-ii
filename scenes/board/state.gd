
const PLAYER_HUMAN = "human"
const PLAYER_AI = "ai"


var current_player = 0
var turn = 1

var players = []



func add_player(type, side):
    self.players.append({
        "type": type,
        "side": side,
        "ap" : 0
    })


func next_player():
    self.current_player += 1
    if self.current_player >= self.players.size():
        self.current_player = 0

func get_current_player():
    return self.players[self.current_player]

func get_current_ap():
    var player_data = self.get_current_player()
    return player_data["ap"]

func add_player_ap(id, value):
    self.players[id]["ap"] += value

func use_player_ap(id, value):
    self.players[id]["ap"] -= value

func use_current_player_ap(value):
    self.use_player_ap(self.current_player, value)

func add_current_player_ap(value):
    self.add_player_ap(self.current_player, value)
