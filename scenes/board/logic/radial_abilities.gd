
var tile_view_template = preload("res://scenes/map_editor/tile_view.tscn")


func is_object_without_abilities(board, context_object):
    if context_object == null:
        return false

    if context_object is board.map.templates.generic_building:
        if context_object.abilities.size() == 0:
            return true

    if context_object is board.map.templates.generic_unit:
        if not context_object.has_moves():
            return true

        return not context_object.has_active_ability()

    return false


func fill_radial_with_abilities(board, radial, context_object):
    if context_object is board.map.templates.generic_building:
        self.fill_radial_with_building_abilities(board, radial, context_object)
    if context_object is board.map.templates.generic_unit:
        self.fill_radial_with_unit_abilities(board, radial,context_object)


func fill_radial_with_building_abilities(board, radial, building):
    radial.set_field(board.ui.icons.back.instance(), "Back", 6, board, "toggle_radial_menu")

    var icon
    var label

    for ability in building.abilities:
        if ability.TYPE == "production" and ability.is_visible(board):
            var icon_model = board.map.templates.get_template(ability.template_name)
            var ap_cost = ability.ap_cost

            ap_cost = board.abilities.get_modified_cost(ap_cost, ability.template_name, building)

            icon_model.set_side_material(board.map.templates.get_side_material(building.side))
            icon = tile_view_template.instance()
            icon.hide_background()
            icon.is_side_tile = false
            icon.viewport_size =  20
            icon.set_tile(icon_model, 0)
            label = ability.label
            label += "\n" + str(ap_cost) + " AP"
            radial.set_field(icon, label, ability.index, board, "activate_production_ability", [ability])

func fill_radial_with_unit_abilities(board, radial, unit):
    radial.set_field(board.ui.icons.back.instance(), "Back", 6, board, "toggle_radial_menu")
    var label
    label = unit.active_ability.label
    if unit.active_ability.ap_cost > 0:
        label += "\n" + str(unit.active_ability.ap_cost) + " AP"
    radial.set_field(board.ui.icons.get_named_icon(unit.active_ability.named_icon), label, unit.active_ability.index, board, "activate_ability", [unit.active_ability])

    if unit.active_ability.is_on_cooldown():
        radial.set_field_disabled(unit.active_ability.index, unit.active_ability.cd_turns_left)
