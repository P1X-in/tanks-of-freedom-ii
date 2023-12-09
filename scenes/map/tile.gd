
var settings

const EAST = "e"
const WEST = "w"
const NORTH = "n"
const SOUTH = "s"

var position = Vector2(0, 0)

var ground = preload("res://scenes/map/tile_fragment.gd").new()
var frame = preload("res://scenes/map/tile_fragment.gd").new()
var decoration = preload("res://scenes/map/tile_fragment.gd").new()
var terrain = preload("res://scenes/map/tile_fragment.gd").new()
var building = preload("res://scenes/map/tile_fragment.gd").new()
var unit = preload("res://scenes/map/tile_fragment.gd").new()
var damage = preload("res://scenes/map/tile_fragment.gd").new()

var fragments = []

var neighbours = {}

var is_state_modified = false

func _init(x, y):
	self.position.x = x
	self.position.y = y

	self.fragments  = [
		self.ground,
		self.frame,
		self.decoration,
		self.terrain,
		self.building,
		self.unit,
		self.damage,
	]

func has_content():
	for fragment in self.fragments:
		if fragment.is_present():
			return true
	return false

func get_dict():
	return {
		"ground" : self.ground.get_dict(),
		"frame" : self.frame.get_dict(),
		"decoration" : self.decoration.get_dict(),
		"terrain" : self.terrain.get_dict(),
		"building" : self.building.get_dict(),
		"unit" : self.unit.get_dict(),
		"damage" : self.damage.get_dict(),
	}

func wipe():
	self.unit.clear()
	self.building.clear()
	self.terrain.clear()
	self.decoration.clear()
	self.frame.clear()
	self.ground.clear()
	self.damage.clear()

func is_selectable(side):
	if self.unit.is_present():
		return self.unit.tile.side == side
	elif self.building.is_present():
		return self.building.tile.side == side

	return false

func add_neighbour(direction, tile):
	self.neighbours[direction] = tile

func get_neighbour(direction):
	if self.neighbours.has(direction):
		return self.neighbours[direction]

	return null

func is_neighbour(tile):
	for direction in self.neighbours.keys():
		if self.neighbours[direction] == tile:
			return true
	return false


func can_acommodate_unit(moving_unit=null):
	if not self.ground.is_present():
		return false
	if self.ground.tile.unit_can_fly and (moving_unit == null or not moving_unit.can_fly):
		return false
	if self.unit.is_present():
		return false
	if self.building.is_present():
		return false
	if self.terrain.is_present():
		return self.terrain.tile.unit_can_stand

	return true

func can_pass_through(moving_unit):
	if not self.ground.is_present():
		return false
	if self.ground.tile.unit_can_fly and not moving_unit.can_fly:
		return false
	if self.building.is_present() and not moving_unit.can_fly:
		return false
	if self.has_enemy_unit(moving_unit.side, moving_unit.team):
		return false
	if self.terrain.is_present() and not moving_unit.can_fly:
		return self.terrain.tile.unit_can_stand

	return true

func has_enemy_unit(side, team=null):
	if self.unit.is_present() && self.unit.tile.side != side && self.unit.tile.team != team:
		return true
	return false

func has_allied_unit(team):
	if self.unit.is_present() && self.unit.tile.team == team:
		return true
	return false

func has_friendly_unit(side):
	if self.unit.is_present() && self.unit.tile.side == side:
		return true
	return false

func has_enemy_building(side, team=null):
	if self.building.is_present() && self.building.tile.side != side && self.building.tile.team != team:
		return true
	return false

func has_allied_building(team):
	if self.building.is_present() && self.building.tile.team == team:
		return true
	return false

func has_friendly_building(side):
	if self.building.is_present() && self.building.tile.side == side:
		return true
	return false

func neighbours_enemy_unit(side, team=null):
	for direction in self.neighbours.keys():
		if self.neighbours[direction].has_enemy_unit(side, team):
			return true
	return false

func can_attack_neightbour_enemy_unit(attacking_unit):
	for direction in self.neighbours.keys():
		if self.neighbours[direction].has_enemy_unit(attacking_unit.side, attacking_unit.team):
			if attacking_unit.can_attack(self.neighbours[direction].unit.tile):
				return true
	return false

func neighbours_enemy_building(side, team=null):
	for direction in self.neighbours.keys():
		if self.neighbours[direction].has_enemy_building(side, team):
			return true
	return false

func get_direction_to_neighbour(tile):
	for direction in self.neighbours.keys():
		if self.neighbours[direction] == tile:
			return direction
	return null

func can_unit_interact(interacting_unit):
	if not interacting_unit.has_moves():
		return false

	if self.has_enemy_unit(interacting_unit.side, interacting_unit.team) && interacting_unit.can_attack(self.unit.tile) && interacting_unit.has_attacks():
		return true

	if self.has_enemy_building(interacting_unit.side, interacting_unit.team) && interacting_unit.can_capture:
		return true

	return false

func has_friendly_hq(side):
	if self.building.is_present() && self.building.tile.side == side && self.building.tile.template_name in ["modern_hq", "steampunk_hq", "futuristic_hq", "feudal_hq"]:
		return true
	return false

func has_friendly_hero(side):
	if self.has_friendly_unit(side) && self.unit.tile.unit_class == "hero":
		return true
	return false

func is_ground_damage_possible():
	if not self.ground.is_present():
		return false
	if self.unit.is_present():
		return false
	if self.building.is_present():
		return false
	if self.terrain.is_present():
		return false
	if self.damage.is_present():
		return false

	return true

func is_object_damage_possible():
	return self.terrain.is_present() and self.terrain.tile.is_damageable()

func is_damageable():
	return self.is_ground_damage_possible() or self.is_object_damage_possible()

func apply_invisibility():
	for fragment in self.fragments:
		if fragment.is_present() and fragment.tile.is_invisible:
			fragment.tile.hide_mesh() 


func _settings_changed(key, _new_value):
	var shadows = self.settings.get_option("shadows")
	var dec_shadows = self.settings.get_option("dec_shadows")

	if key == "shadows" or key == "dec_shadows":
		if shadows:
			if self.ground.is_present():
				self.ground.tile.enable_shadow()

			if self.terrain.is_present():
				self.terrain.tile.enable_shadow()

			if self.building.is_present():
				self.building.tile.enable_shadow()

			if self.unit.is_present():
				self.unit.tile.enable_shadow()

			if dec_shadows:
				if self.frame.is_present():
					self.frame.tile.enable_shadow()
				if self.decoration.is_present():
					self.decoration.tile.enable_shadow()
			else:
				if self.frame.is_present():
					_disable_shadow(self.frame.tile, shadows)
				if self.decoration.is_present():
					_disable_shadow(self.decoration.tile, shadows)
		else:
			if self.ground.is_present():
				_disable_shadow(self.ground.tile, shadows)
			if self.frame.is_present():
				_disable_shadow(self.frame.tile, shadows)
			if self.decoration.is_present():
				_disable_shadow(self.decoration.tile, shadows)
			if self.terrain.is_present():
				_disable_shadow(self.terrain.tile, shadows)
			if self.building.is_present():
				_disable_shadow(self.building.tile, shadows)
			if self.unit.is_present():
				_disable_shadow(self.unit.tile, shadows)

func _disable_shadow(tile, shadow_setting):
	if tile.shadow_override and shadow_setting:
		return

	tile.disable_shadow()
