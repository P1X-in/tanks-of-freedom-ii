class_name Collateral

const COLLATERAL_CHANCE = 0.5

var board:GameBoard = null

func _init(board_object:GameBoard):
	self.board = board_object

func damage_tile(tile):
	if tile.damage.is_present() or tile.terrain.is_present() or tile.ground.tile.unit_can_fly:
		return null

	var angles = [0, 90, 180, 270]
	var damage_templates = [
		self.board.map.templates.DECO_GROUND_DMG_1,
		self.board.map.templates.DECO_GROUND_DMG_2,
		self.board.map.templates.DECO_GROUND_DMG_5,
		self.board.map.templates.DECO_GROUND_DMG_6,
	]

	if tile.decoration.is_present():
		tile.decoration.clear()

	var random_angle = angles[randi() % angles.size()]
	var random_template = damage_templates[randi() % damage_templates.size()]
	apply_tile_damage(tile.position, random_template, random_angle)

	return [tile.position, random_template, random_angle]

func apply_tile_damage(tile_position, template, angle):
	self.board.map.builder.place_damage(tile_position, template, angle)
	self.board.map.model.get_tile(tile_position).is_state_modified = true

func generate_collateral(tile):
	var summary = []

	for neighbour in tile.neighbours.values():
		if randf() <= self.COLLATERAL_CHANCE:
			if self.damage_terrain(neighbour):
				summary.append(neighbour.position)

	return summary

func damage_terrain(tile):
	if not tile.terrain.is_present():
		return false

	if not tile.terrain.tile.is_damageable():
		return false

	var next_damage_stage_template = tile.terrain.tile.next_damage_stage_template
	var rotation = tile.terrain.tile.get_rotation_degrees()

	tile.terrain.clear()
	self.board.map.builder.place_terrain(tile.position, next_damage_stage_template, rotation.y)
	tile.terrain.tile.show_explosion()
	tile.is_state_modified = true

	return true
