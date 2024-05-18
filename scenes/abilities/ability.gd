extends Node

var TYPE="undefined"

@export var dlc_version = 1
@export var index = 0
@export var label = ""
@export var description = ""
@export var ap_cost = 0
@export var cooldown = 0
@export var ability_range = 0
@export var draw_range = 0
@export var in_line = false
var source = null
var active_source_tile = null
var cd_turns_left = 0
var disabled = false

func _ready():
	self.signal_to_parent()
	
func signal_to_parent():
	self.receive_signal(self.get_parent())

func receive_signal(receiver):
	receiver.register_ability(self)
	self.source = receiver

func execute(board, position):
	self._execute(board, position)
	board.events.emit_ability_used(self, position)
	self.activate_cooldown(board)

func _execute(_board, _position):
	return

func is_visible(_board=null):
	if self.disabled:
		return false

	return self._is_visible(_board)

func _is_visible(_board):
	return true

func is_available(_board=null):
	return true

func is_on_cooldown():
	return self.cd_turns_left > 0

func activate_cooldown(board):
	var modified_cooldown = board.abilities.get_modified_cooldown(self.cooldown, self.source.side)

	self.cd_turns_left = modified_cooldown

func reset_cooldown():
	self.cd_turns_left = 0

func cd_tick_down():
	if self.cd_turns_left > 0:
		self.cd_turns_left -= 1

func get_cost():
	return self.ap_cost
