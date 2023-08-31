extends Control

const PLAYER_HUMAN = "human"
const PLAYER_AI = "ai"
const PLAYER_HUMAN_LABEL = "TR_HUMAN"
const PLAYER_AI_LABEL = "AI"

const AP_STEP = 50
const AP_MAX = 150

@onready var blue_player = $"blue_player"
@onready var red_player = $"red_player"
@onready var yellow_player = $"yellow_player"
@onready var green_player = $"green_player"
@onready var black_player = $"black_player"

@onready var blue_border = $"border_blue"
@onready var red_border = $"border_red"
@onready var yellow_border = $"border_yellow"
@onready var green_border = $"border_green"
@onready var black_border = $"border_black"

@onready var type_button = $"player_type"
@onready var ap_button = $"starting_ap"
@onready var team_button = $"team"
@onready var swap_button = $"swap"

var side
var ap
var type
@export var team = 1
@export var index = 0
@export var swap_target: NodePath
var swap_target_node: Node

@onready var audio = $"/root/SimpleAudioLibrary"


func _ready():
	self.swap_target_node = self.get_node(self.swap_target)

func fill_panel(player_side):
	self._reset_labels()

	self.side = player_side

	match player_side:
		"blue":
			self.blue_player.show()
			self.blue_border.show()
		"red":
			self.red_player.show()
			self.red_border.show()
		"yellow":
			self.yellow_player.show()
			self.yellow_border.show()
		"green":
			self.green_player.show()
			self.green_border.show()
		"black":
			self.black_player.show()
			self.black_border.show()

func _reset_labels():
	self.blue_player.hide()
	self.red_player.hide()
	self.yellow_player.hide()
	self.green_player.hide()
	self.black_player.hide()

	self.blue_border.hide()
	self.red_border.hide()
	self.yellow_border.hide()
	self.green_border.hide()
	self.black_border.hide()

	self.ap = self.AP_STEP
	self.type = self.PLAYER_HUMAN
	self.side = null

	self._update_type_label()
	self._update_ap_label()
	self._update_team_label()

	if self.index == 0:
		self.swap_button.hide()

func _update_type_label():
	if self.type == self.PLAYER_HUMAN:
		self.type_button.set_text(self.PLAYER_HUMAN_LABEL)
	else:
		self.type_button.set_text(self.PLAYER_AI_LABEL)

func _update_ap_label():
	self.ap_button.set_text(str(self.ap) + " AP")

func _update_team_label():
	self.team_button.set_text(tr("TR_TEAM") + " " + str(self.team))

func _on_player_type_pressed():
	self.audio.play("menu_click")
	if self.type == self.PLAYER_HUMAN:
		self.type = self.PLAYER_AI
	else:
		self.type = self.PLAYER_HUMAN
	self._update_type_label()


func _on_starting_ap_pressed():
	self.audio.play("menu_click")
	self.ap += self.AP_STEP
	if self.ap > self.AP_MAX:
		self.ap = 0
	self._update_ap_label()


func _on_swap_pressed():
	self.audio.play("menu_click")
	var own_side = self.side
	var own_ap = self.ap
	var own_type = self.type

	self.fill_panel(self.swap_target_node.side)
	self.ap = self.swap_target_node.ap
	self.type = self.swap_target_node.type
	self._update_type_label()
	self._update_ap_label()

	self.swap_target_node.fill_panel(own_side)
	self.swap_target_node.ap = own_ap
	self.swap_target_node.type = own_type
	self.swap_target_node._update_type_label()
	self.swap_target_node._update_ap_label()

func _on_team_pressed():
	self.team += 1
	if self.team > 4:
		self.team = 1
	self._update_team_label()
