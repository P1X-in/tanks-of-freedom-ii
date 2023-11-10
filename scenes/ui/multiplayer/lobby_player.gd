extends Control

signal player_joined(index)
signal player_left(index)
signal state_changed(index)
signal swap_happened(index)

const AP_STEP = 50
const AP_MAX = 150

@onready var player = $"player"

@onready var icon_anchor = $"icon"

@onready var join_button = $"join"
@onready var join_button_label = $"join/label"
@onready var ap_button = $"starting_ap"
@onready var ap_button_label = $"starting_ap/label"
@onready var ap_button_label2 = $"starting_ap_label"
@onready var team_button = $"team"
@onready var team_button_label = $"team/label"
@onready var team_button_label2 = $"team_label"
@onready var swap_button = $"swap"

var side
var ap

var player_peer_id

@export var team = 1
var original_team
@export var index = 0
@export var swap_target: NodePath
var swap_target_node: Node
var attached_icon
var locked_out = false

@onready var audio = $"/root/SimpleAudioLibrary"
@onready var multiplayer_srv = $"/root/Multiplayer"
var icons = preload("res://scenes/ui/icons/icons.gd").new()

func _ready():
	self.swap_target_node = self.get_node(self.swap_target)
	self.original_team = self.team

func fill_panel(player_side):
	self._reset_labels()

	self.side = player_side
	self._set_icon(self.icons.get_named_icon(side + "_gem"))

	if not multiplayer.is_server():
		self.ap_button.hide()
		self.ap_button_label2.show()
		self.team_button.hide()
		self.team_button_label2.show()
		self.swap_button.hide()

func _reset_labels():
	if self.attached_icon != null:
		self.attached_icon.queue_free()
		self.attached_icon = null

	self.ap = self.AP_STEP
	self.side = null
	self.team = self.original_team
	self.player_peer_id = null
	self.locked_out = false

	self._update_join_label()
	self._update_ap_label()
	self._update_team_label()

	self.ap_button.show()
	self.ap_button_label2.hide()
	self.team_button.show()
	self.team_button_label2.hide()
	self.swap_button.show()

	if self.index == 0:
		self.swap_button.hide()

func _set_icon(new_icon):
	if self.attached_icon != null:
		self.attached_icon.queue_free()
		self.attached_icon = null

	if new_icon != null:
		self.icon_anchor.add_child(new_icon)
		self.attached_icon = new_icon

func _update_join_label():
	self.join_button.show()
	if self.player_peer_id == null:
		self.join_button_label.set_text(tr("TR_JOIN"))
	else:
		self.join_button_label.set_text(tr("TR_LEAVE"))
		if self.player_peer_id != multiplayer.get_unique_id():
			self.join_button.hide()
	if self.locked_out:
		self.join_button.hide()

	if self.player_peer_id == null:
		self.player.set_text(tr("TR_UNASSIGNED"))
	else:
		if self.multiplayer_srv.players.has(self.player_peer_id):
			self.player.set_text(self.multiplayer_srv.players[self.player_peer_id]["name"])

func lock_side():
	self.locked_out = true
	_update_join_label()

func unlock_side():
	self.locked_out = false
	_update_join_label()

func _update_ap_label():
	self.ap_button_label.set_text(str(self.ap) + " AP")
	self.ap_button_label2.set_text(str(self.ap) + " AP")

func _update_team_label():
	self.team_button_label.set_text(tr("TR_TEAM") + " " + str(self.team))
	self.team_button_label2.set_text(tr("TR_TEAM") + " " + str(self.team))

func _on_starting_ap_pressed():
	self.audio.play("menu_click")
	self.ap += self.AP_STEP
	if self.ap > self.AP_MAX:
		self.ap = 0
	self._update_ap_label()
	state_changed.emit(self.index)


func _on_swap_pressed():
	self.audio.play("menu_click")
	_perform_panel_swap()
	swap_happened.emit(self.index)

func _perform_panel_swap():
	var own_side = self.side
	var own_ap = self.ap
	var own_team = self.team
	var own_peer_id = self.player_peer_id
	var own_lock = self.locked_out

	self.fill_panel(self.swap_target_node.side)
	self.ap = self.swap_target_node.ap
	self.team = self.swap_target_node.team
	self.player_peer_id = self.swap_target_node.player_peer_id
	self.locked_out = self.swap_target_node.locked_out
	self._update_join_label()
	self._update_ap_label()
	self._update_team_label()

	self.swap_target_node.fill_panel(own_side)
	self.swap_target_node.ap = own_ap
	self.swap_target_node.team = own_team
	self.swap_target_node.player_peer_id = own_peer_id
	self.swap_target_node.locked_out = own_lock
	self.swap_target_node._update_join_label()
	self.swap_target_node._update_ap_label()
	self.swap_target_node._update_team_label()

func _on_team_pressed():
	self.team += 1
	if self.team > 4:
		self.team = 1
	self._update_team_label()
	state_changed.emit(self.index)


func _on_join_pressed():
	if self.player_peer_id == null:
		_set_peer_id(multiplayer.get_unique_id())
		player_joined.emit(self.index)
	else:
		_set_peer_id(null)
		player_left.emit(self.index)

func _set_peer_id(peer_id):
	self.player_peer_id = peer_id
	_update_join_label()

func _set_ap(new_ap):
	self.ap = new_ap
	_update_ap_label()

func _set_team(new_team):
	self.team = new_team
	_update_team_label()
