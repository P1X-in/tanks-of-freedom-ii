extends Node

var setup = []
var stored_setup = []
var map_name

var campaign_name = null
var mission_no = 0

var campaign_win = false
var has_won = false
var animate_medal = false

var restore_save_id = null

func reset():
    self.setup = []
    self.map_name = null
    self.campaign_name = null
    self.mission_no = 0
    self.campaign_win = false
    self.has_won = false
    self.animate_medal = false
    self.restore_save_id = null

func store_setup():
    self.stored_setup = self.setup
func restore_setup():
    self.setup = self.stored_setup

func add_player(side, ap, type, alive=true, team=null):
    self.setup.append({
        "side" : side,
        "ap" : ap,
        "type": type,
        "alive": alive,
        "team": team
    })
