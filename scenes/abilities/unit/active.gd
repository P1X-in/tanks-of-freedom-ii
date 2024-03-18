extends Ability
class_name ActiveAbility

@export var named_icon: String = ""
@export var marker_colour: String = "green"

func _init() -> void:
	self.TYPE = "active"

func execute(board: GameBoard, position: Vector2) -> void:
	super.execute(board, position)
	board.use_current_player_ap(self.ap_cost)
	self.source.use_move(1)

	if not board.state.is_current_player_ai():
		board.active_ability = null
		position = board.selected_tile.position
		board.unselect_tile()
		board.select_tile(position)

func is_tile_applicable(_tile: ModelTile, _source_tile: ModelTile) -> bool:
	return true
