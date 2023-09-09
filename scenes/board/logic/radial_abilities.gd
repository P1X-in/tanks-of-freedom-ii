
var tile_view_template = preload("res://scenes/map_editor/tile_view.tscn")


func is_object_without_abilities(_board, context_object, include_disabled=false):
	if context_object == null:
		return false

	if context_object is BaseBuilding:
		if include_disabled:
			return context_object.abilities.size() == 0
		for ability in context_object.abilities:
			if not ability.disabled:
				return false
		return true

	if context_object is BaseUnit:
		if not context_object.has_moves():
			return true

		return not context_object.has_active_ability()

	return false


func fill_radial_with_abilities(board, radial, context_object):
	if context_object is BaseBuilding:
		self.fill_radial_with_building_abilities(board, radial, context_object)
	if context_object is BaseUnit:
		self.fill_radial_with_unit_abilities(board, radial,context_object)


func fill_radial_with_building_abilities(board, radial, building):
	radial.set_field(board.ui.icons.cross.instantiate(), "TR_CLOSE", 6, board, "toggle_radial_menu")

	var icon
	var label

	for ability in building.abilities:
		if ability.TYPE == "production" and ability.is_visible(board):
			var icon_model = board.map.templates.get_template(ability.template_name)
			var ap_cost = ability.ap_cost

			ap_cost = board.abilities.get_modified_cost(ap_cost, ability.template_name, building)

			icon_model.set_side_material(board.map.templates.get_side_material(building.side))
			icon = tile_view_template.instantiate()
			icon.hide_background()
			icon.is_side_tile = false
			icon.viewport_size =  20
			icon.set_tile(icon_model, 0)
			label = tr(ability.label)
			label += "\n" + str(ap_cost) + " " + tr("TR_AP")
			if not board.state.can_current_player_afford(ap_cost):
				label += "\n" + tr("TR_NOT_ENOUGH_AP")
				radial.set_field_disabled(ability.index, "")
				
			radial.set_field(icon, label, ability.index, board, "activate_production_ability", [ability])

func fill_radial_with_unit_abilities(board, radial, unit):
	radial.set_field(board.ui.icons.cross.instantiate(), "TR_CLOSE", 6, board, "toggle_radial_menu")
	var label

	for ability in unit.active_abilities:
		if ability.is_visible(board):
			label = tr(ability.label)
			if ability.ap_cost > 0:
				label += "\n" + str(ability.ap_cost) + " " + tr("TR_AP")
				if not board.state.can_current_player_afford(ability.ap_cost):
					label += "\n" + tr("TR_NOT_ENOUGH_AP")
					radial.set_field_disabled(ability.index, "")
			radial.set_field(board.ui.icons.get_named_icon(ability.named_icon), label, ability.index, board, "activate_ability", [ability])

			if ability.is_on_cooldown():
				radial.set_field_disabled(ability.index, ability.cd_turns_left)

func fill_radial_with_ability_bans(editor, radial, context_object):
	if context_object is BaseBuilding:
		self.fill_radial_with_building_abilities_bans(editor, radial, context_object)

func fill_radial_with_building_abilities_bans(editor, radial, building):
	radial.set_field(editor.ui.icons.cross.instantiate(), "TR_CLOSE", 6, editor, "toggle_radial_menu")

	var icon
	var label

	for ability in building.abilities:
		if ability.TYPE == "production":
			var icon_model = editor.map.templates.get_template(ability.template_name)

			icon_model.set_side_material(editor.map.templates.get_side_material(building.side))
			icon = tile_view_template.instantiate()
			icon.hide_background()
			icon.is_side_tile = false
			icon.viewport_size =  20
			icon.set_tile(icon_model, 0)
			label = tr(ability.label)
			label += "\n" + str(ability.ap_cost) + " " + tr("TR_AP")
			radial.set_field(icon, label, ability.index, self, "_ban_ability", [ability, radial])
			if ability.disabled:
				radial.set_field_disabled(ability.index, "X")

func _ban_ability(args):
	var ability = args[0]
	var radial = args[1]

	ability.disabled = not ability.disabled

	if ability.disabled:
		radial.set_field_disabled(ability.index, "X")
	else:
		radial.clear_field_disabled(ability.index)
