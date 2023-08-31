extends "res://scenes/tiles/units/unit.gd"

func can_attack(_unit):
	return false

func set_side_material(material):
	if material == null:
		return

	super.set_side_material(material)
	$"mesh_anchor/standard".set_surface_override_material(0, material)

func disable_shadow():
	super.disable_shadow()

	$"mesh_anchor/standard".cast_shadow = 0

func reset_position_for_tile_view():
	super.reset_position_for_tile_view()
	$"mesh_anchor/standard".hide()

