class_name MatchSetupData
extends Node

var setup: Array = []
var stored_setup: Array = []
var map_name

var campaign_name = null
var mission_no: int = 0

var campaign_win: bool = false
var has_won: bool = false
var animate_medal: bool = false

var restore_save_id = null
var is_multiplayer: bool = false

var turn_limit: int = 0
var time_limit: int = 0


func reset() -> void:
	self.setup = []
	self.map_name = null
	self.campaign_name = null
	self.mission_no = 0
	self.campaign_win = false
	self.has_won = false
	self.animate_medal = false
	self.restore_save_id = null
	self.is_multiplayer = false
	self.turn_limit = 0
	self.time_limit = 0


func store_setup() -> void:
	self.stored_setup = self.setup


func restore_setup() -> void:
	self.setup = self.stored_setup


func add_player(side, ap, type, alive=true, team=null, peer_id=null) -> void:
	self.setup.append({
		"side" : side,
		"ap" : ap,
		"type": type,
		"alive": alive,
		"team": team,
		"peer_id": peer_id
	})
