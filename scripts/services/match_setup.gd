extends Node

var setup = []
var map_name

func reset():
    self.setup = []
    self.map_name = null

func add_player(side, ap, type):
    self.setup.append({
        "side" : side,
        "ap" : ap,
        "type": type
    })
