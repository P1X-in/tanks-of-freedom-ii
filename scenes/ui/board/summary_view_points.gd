class_name SidePointsSummary
extends Control


var _icons_factory: IconsFactory = IconsFactory.new()
var _current_icon: Node

var _building_points: int = 0
var _unit_points: int = 0
var _ap_points: int = 0


func show_player_points(player_data: Dictionary, board) -> void:
	_set_icon(player_data["side"])
	_calculate_building_points(player_data["side"], board)
	_calculate_unit_points(player_data["side"], board)
	_calculate_ap_points(player_data)
	_calculate_total_points()


func _set_icon(side: String) -> void:
	if _current_icon:
		_current_icon.queue_free()
	_current_icon = _icons_factory.get_named_icon(side + "_gem")
	$background/icon_anchor/icon_anchor.add_child(_current_icon)


func _calculate_building_points(side: String, board) -> void:
	_building_points = 0
	for tile in board.map.model.tiles.values():
		if tile.building.is_present() and tile.building.tile.side == side:
			_building_points += tile.building.tile.capture_value
	$background/building_points.set_text(str(_building_points))


func _calculate_unit_points(side: String, board) -> void:
	_unit_points = 0
	for tile in board.map.model.tiles.values():
		if tile.unit.is_present() and tile.unit.tile.side == side:
			_unit_points += tile.unit.tile.get_value()
	$background/unit_points.set_text(str(_unit_points))


func _calculate_ap_points(player_data: Dictionary) -> void:
	_ap_points = player_data["ap"]
	$background/ap_points.set_text(str(_ap_points))


func _calculate_total_points() -> void:
	$background/total_points.set_text(str(_building_points + _unit_points + _ap_points))
