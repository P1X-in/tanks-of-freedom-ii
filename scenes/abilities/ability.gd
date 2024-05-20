extends Node
class_name Ability

var TYPE: String = "undefined"

@export var dlc_version: int = 1
@export var index: int = 0
@export var label: String = ""
@export var description: String = ""
@export var ap_cost: int = 0
@export var cooldown: int = 0
@export var ability_range: int = 0
@export var draw_range: int = 0
@export var in_line: bool = false
var source: MapTile = null
var active_source_tile: ModelTile = null
var cd_turns_left: int = 0
var disabled: bool = false

func _ready() -> void:
	self.signal_to_parent()
	
func signal_to_parent() -> void:
	self.receive_signal(self.get_parent())

func receive_signal(receiver: MapTile) -> void:
	receiver.register_ability(self)
	self.source = receiver

func execute(board: GameBoard, position: Vector2) -> void:
	self._execute(board, position)
	board.events.emit_ability_used(self, position)
	self.activate_cooldown(board)

func _execute(_board: GameBoard, _position: Vector2) -> void:
	return

func is_visible(_board: GameBoard = null) -> bool:
	if self.disabled:
		return false

	return self._is_visible(_board)

func _is_visible(_board: GameBoard) -> bool:
	return true

func is_available(_board: GameBoard = null) -> bool:
	return true

func is_on_cooldown() -> bool:
	return self.cd_turns_left > 0

func activate_cooldown(board: GameBoard) -> void:
	var modified_cooldown: int = board.abilities.get_modified_cooldown(self.cooldown, self.source)

	self.cd_turns_left = modified_cooldown

func reset_cooldown() -> void:
	self.cd_turns_left = 0

func cd_tick_down() -> void:
	if self.cd_turns_left > 0:
		self.cd_turns_left -= 1

func get_cost():
	return self.ap_cost
