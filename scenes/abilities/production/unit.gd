extends "res://scenes/abilities/ability.gd"

@export var template_name = ""

func _init():
	self.TYPE = "production"

func _execute(board, position):
	var new_unit = board.map.builder.place_unit(position, self.template_name, 0, board.state.get_current_side())
	var cost = self.ap_cost
	cost = board.abilities.get_modified_cost(cost, self.template_name, self.source)
	board.use_current_player_ap(cost)

	new_unit.replenish_moves()
	new_unit.team = board.state.get_player_team(board.state.get_current_side())
	board.abilities.apply_passive_modifiers(new_unit)
	new_unit.sfx_effect("spawn")

	if board.abilities.get_initial_level(self.template_name, self.source) > 0:
		new_unit.level_up()

	if not board.state.is_current_player_ai():
		board.active_ability = null
		board.select_tile(position)

	board.events.emit_unit_spawned(self.source, new_unit)
