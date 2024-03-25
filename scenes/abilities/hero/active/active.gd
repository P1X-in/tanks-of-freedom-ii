extends HeroAbility
class_name HeroActiveAbility

@export var named_icon: String = ""
@export var marker_colour: String = "green"

func _init() -> void:
	self.TYPE = "hero_active"

func execute(board: GameBoard, position: Vector2) -> void:
	super.execute(board, position)
	board.use_current_player_ap(self.ap_cost)
	self.source.use_move(1)

func is_tile_applicable(_tile: ModelTile, _source_tile: ModelTile) -> bool:
	return true
