extends Node

var setup = []
var map_name

var campaign_name = null
var mission_no = 0

var campaign_win = false

func reset():
    self.setup = []
    self.map_name = null
    self.campaign_name = null
    self.mission_no = 0

func add_player(side, ap, type):
    self.setup.append({
        "side" : side,
        "ap" : ap,
        "type": type
    })
