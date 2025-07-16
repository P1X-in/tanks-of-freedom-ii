class_name SpawnHero
extends SpawnUnit

@export_enum("admiral", "captain", "commando", "general", "gentleman", "noble", "prince", "warlord") var hero: String

func _get_template_name():
	return "hero_" + hero

func _is_visible(board=null):
	if self.source == null:
		return false

	if board == null:
		return false

	if board.state.has_side_a_hero(self.source.side):
		return false

	return true
