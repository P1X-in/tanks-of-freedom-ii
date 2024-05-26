class_name Ability
extends Resource

@export var TYPE="undefined"

@export var dlc_version: int = 1
@export var index: int = 1
@export var label: String = ""
@export var description: String = ""
@export var ap_cost: int = 0
@export var cooldown: int = 0
@export var ability_range: int = 0
@export var draw_range: int = 0
@export var in_line: bool = false
var source = null
var active_source_tile = null
var cd_turns_left = 0
var disabled = false
var side = null

func subscribe_for_ability(subscriber):
	self.source = subscriber
	self.side = subscriber.side

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
	var modified_cooldown = board.abilities.get_modified_cooldown(self.cooldown, self.side)

	self.cd_turns_left = modified_cooldown

func reset_cooldown():
	self.cd_turns_left = 0

func cd_tick_down():
	if self.cd_turns_left > 0:
		self.cd_turns_left -= 1

func get_cost():
	return self.ap_cost
