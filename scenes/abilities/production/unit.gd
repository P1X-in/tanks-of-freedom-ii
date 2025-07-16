class_name SpawnUnit
extends Ability

@export_enum("heli", "infantry", "m_inf", "rocket", "scout", "tank") var unit: String
var style: String

var template_name: String:
	get = _get_template_name
func _get_template_name():
	return style + "_" + unit

func _init():
	self.TYPE = "production"

func subscribe_for_ability(subscriber: BaseBuilding):
	super.subscribe_for_ability(subscriber)
	self.style = subscriber.side

func _execute(board, position):
	var new_unit = board.map.builder.place_unit(position, self.template_name, 0, board.state.get_current_side())
	var cost = self.ap_cost
	cost = board.abilities.get_modified_cost(cost, self.template_name, self.side)
	board.use_current_player_ap(cost)

	new_unit.replenish_moves()
	new_unit.team = board.state.get_player_team(board.state.get_current_side())
	board.abilities.apply_passive_modifiers(new_unit)
	new_unit.sfx_effect("spawn")

	if board.abilities.get_initial_level(self.template_name, self.side) > 0:
		new_unit.level_up()

	if not board.state.is_current_player_ai():
		board.active_ability = null
		board.select_tile(position)

	board.events.emit_unit_spawned(self.source, new_unit)
