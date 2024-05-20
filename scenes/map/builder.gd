
const CLASS_GROUND = "ground"
const CLASS_FRAME = "frame"
const CLASS_DECORATION = "decoration"
const CLASS_TERRAIN = "terrain"
const SUB_CLASS_CONSTRUCTION = "construction"
const CLASS_BUILDING = "building"
const CLASS_UNIT = "unit"
const CLASS_DAMAGE = "damage"
const CLASS_HERO = "hero"

var map

var editor = null
var enable_health = false

func _init(map_scene):
    self.map = map_scene


func place_ground(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if tile.ground.is_present():
        self._notify_removal(tile.ground, position, self.map.builder.CLASS_GROUND)
        tile.ground.clear()

    var new_element = self.place_element(position, name, rotation, 0, self.map.tiles_ground_anchor, tile.ground)
    if not self.map.settings.get_option("shadows"):
        self._disable_shadow(new_element)


func place_frame(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if not tile.ground.is_present():
        return

    if tile.frame.is_present():
        self._notify_removal(tile.frame, position, self.map.builder.CLASS_FRAME)
        tile.frame.clear()

    var new_element = self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_frames_anchor, tile.frame)
    if not self.map.settings.get_option("shadows") or not self.map.settings.get_option("dec_shadows"):
        self._disable_shadow(new_element)

func place_decoration(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if not tile.ground.is_present():
        return
    if tile.decoration.is_present():
        self._notify_removal(tile.decoration, position, self.map.builder.CLASS_DECORATION)
        tile.decoration.clear()
    if tile.damage.is_present():
        self._notify_removal(tile.damage, position, self.map.builder.CLASS_DAMAGE)
        tile.damage.clear()
    if tile.building.is_present():
        self._notify_removal(tile.building, position, self.map.builder.CLASS_BUILDING, tile.building.tile.side, tile.building.tile._get_abilities_status())
        tile.building.clear()

    var new_element = self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_frames_anchor, tile.decoration)

    if tile.terrain.is_present() and (not new_element.can_share_space or not tile.terrain.tile.can_share_space):
        self._notify_removal(tile.terrain, position, self.map.builder.CLASS_TERRAIN)
        tile.terrain.clear()

    if not self.map.settings.get_option("shadows") or not self.map.settings.get_option("dec_shadows"):
        self._disable_shadow(new_element)

func place_damage(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if not tile.ground.is_present():
        return
    if tile.decoration.is_present():
        self._notify_removal(tile.decoration, position, self.map.builder.CLASS_DECORATION)
        tile.decoration.clear()
    if tile.terrain.is_present():
        self._notify_removal(tile.terrain, position, self.map.builder.CLASS_TERRAIN)
        tile.terrain.clear()
    if tile.building.is_present():
        self._notify_removal(tile.building, position, self.map.builder.CLASS_BUILDING, tile.building.tile.side, tile.building.tile._get_abilities_status())
        tile.building.clear()
    if tile.damage.is_present():
        self._notify_removal(tile.damage, position, self.map.builder.CLASS_DAMAGE)
        tile.damage.clear()

    var new_element = self.place_element(position, name, rotation, self.map.GROUND_HEIGHT - 0.05, self.map.tiles_frames_anchor, tile.damage)
    self._disable_shadow(new_element)

func place_terrain(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if not tile.ground.is_present():
        return
    if tile.unit.is_present():
        self._notify_removal(tile.unit, position, self.map.builder.CLASS_UNIT, tile.unit.tile.side)
        tile.unit.clear()
    if tile.terrain.is_present():
        self._notify_removal(tile.terrain, position, self.map.builder.CLASS_TERRAIN)
        tile.terrain.clear()
    if tile.building.is_present():
        self._notify_removal(tile.building, position, self.map.builder.CLASS_BUILDING, tile.building.tile.side, tile.building.tile._get_abilities_status())
        tile.building.clear()
    if tile.damage.is_present():
        self._notify_removal(tile.damage, position, self.map.builder.CLASS_DAMAGE)
        tile.damage.clear()

    var new_element = self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_terrain_anchor, tile.terrain)
    
    if tile.decoration.is_present() and (not new_element.can_share_space or not tile.decoration.tile.can_share_space):
        self._notify_removal(tile.decoration, position, self.map.builder.CLASS_DECORATION)
        tile.decoration.clear()

    if not self.map.settings.get_option("shadows"):
        self._disable_shadow(new_element)

func place_building(position, name, rotation, side=null):
    var tile = self.map.model.get_tile(position)

    if not tile.ground.is_present():
        return
    if tile.decoration.is_present():
        self._notify_removal(tile.decoration, position, self.map.builder.CLASS_DECORATION)
        tile.decoration.clear()
    if tile.unit.is_present():
        self._notify_removal(tile.unit, position, self.map.builder.CLASS_UNIT, tile.unit.tile.side)
        tile.unit.clear()
    if tile.terrain.is_present():
        self._notify_removal(tile.terrain, position, self.map.builder.CLASS_TERRAIN)
        tile.terrain.clear()
    if tile.building.is_present():
        self._notify_removal(tile.building, position, self.map.builder.CLASS_BUILDING, tile.building.tile.side, tile.building.tile._get_abilities_status())
        tile.building.clear()
    if tile.damage.is_present():
        self._notify_removal(tile.damage, position, self.map.builder.CLASS_DAMAGE)
        tile.damage.clear()

    var new_element = self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_buildings_anchor, tile.building)
    if not self.map.settings.get_option("shadows"):
        self._disable_shadow(new_element)

    if side != null:
        self.set_building_side(position, side)

    new_element.disable_dlc_abilities(self.map.model.metadata["editor_version"])

func place_unit(position, name, rotation, side=null, ai_paused=false):
    var tile = self.map.model.get_tile(position)

    if not tile.ground.is_present():
        return

    return self.force_place_unit(position, name, rotation, side, ai_paused)

func force_place_unit(position, name, rotation, side=null, ai_paused=false):
    var tile = self.map.model.get_tile(position)

    if tile.unit.is_present():
        self._notify_removal(tile.unit, position, self.map.builder.CLASS_UNIT, tile.unit.tile.side)
        tile.unit.clear()
    if tile.building.is_present():
        self._notify_removal(tile.building, position, self.map.builder.CLASS_BUILDING, tile.building.tile.side, tile.building.tile._get_abilities_status())
        tile.building.clear()
    if tile.terrain.is_present() and not tile.can_acommodate_unit():
        self._notify_removal(tile.terrain, position, self.map.builder.CLASS_TERRAIN)
        tile.terrain.clear()


    var new_unit = self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_units_anchor, tile.unit)
    if not self.map.settings.get_option("shadows"):
        self._disable_shadow(new_unit)

    if side != null:
        self.set_unit_side(position, side)
    else:
        self.set_unit_side(position, tile.unit.tile.side)
    tile.unit.tile.ai_paused = ai_paused
    tile.unit.tile.reset()

    if ai_paused:
        tile.unit.tile.remove_highlight()

    new_unit.disable_dlc_abilities(self.map.model.metadata["editor_version"])
    if self.enable_health and self.map.settings.get_option("show_health"):
        new_unit.enable_health()

    if self.map.model.metadata.has("allow_level_up"):
        new_unit.allow_level_up = self.map.model.metadata["allow_level_up"]

    return new_unit


func place_element(position, name, rotation, vertical_offset, anchor, tile_fragment):
    var new_tile = self.map.templates.get_template(name)
    var world_position = self.map.map_to_local(position)

    anchor.add_child(new_tile)
    world_position.y = vertical_offset
    new_tile.set_position(world_position)
    new_tile.set_rotation(Vector3(0, deg_to_rad(rotation), 0))
    new_tile.current_rotation = rotation

    tile_fragment.set_tile(new_tile)

    return new_tile

func clear_tile_layer(position):
    var tile = self.map.model.get_tile(position)

    if tile.unit.is_present():
        self._notify_removal(tile.unit, position, self.map.builder.CLASS_UNIT, tile.unit.tile.side, {}, false)
        tile.unit.clear()
    elif tile.building.is_present():
        self._notify_removal(tile.building, position, self.map.builder.CLASS_BUILDING, tile.building.tile.side, tile.building.tile._get_abilities_status(), false)
        tile.building.clear()
    elif tile.terrain.is_present():
        self._notify_removal(tile.terrain, position, self.map.builder.CLASS_TERRAIN, null, {}, false)
        tile.terrain.clear()
    elif tile.decoration.is_present():
        self._notify_removal(tile.decoration, position, self.map.builder.CLASS_DECORATION, null, {}, false)
        tile.decoration.clear()
    elif tile.damage.is_present():
        self._notify_removal(tile.damage, position, self.map.builder.CLASS_DAMAGE, null, {}, false)
        tile.damage.clear()
    elif tile.frame.is_present():
        self._notify_removal(tile.frame, position, self.map.builder.CLASS_FRAME, null, {}, false)
        tile.frame.clear()
    elif tile.ground.is_present():
        self._notify_removal(tile.ground, position, self.map.builder.CLASS_GROUND, null, {}, false)
        tile.ground.clear()

func wipe_tile(position):
    var tile = self.map.model.get_tile(position)

    tile.wipe()

func wipe_map():
    for tile_id in self.map.model.tiles.keys():
        self.map.model.tiles[tile_id].wipe()

func fill_map_from_data(data):
    var tiles_data = data["tiles"]
    var scripts = {
        "stories" : {},
        "triggers" : {}
    }

    if data.has("scripts"):
        scripts = data["scripts"]

    if data.has("metadata"):
        self.map.model.metadata = data["metadata"]

    self.attach_mouse_layer()

    for tile_id in self.map.model.tiles.keys():
        if tiles_data.has(tile_id):
            self.place_tile(tile_id, tiles_data[tile_id])

    self.map.model.ingest_scripts(scripts)

func attach_mouse_layer():
    var ground_point
    var tile

    self.map.mouse_layer.initialize(self.map.model.SIZE, self.map.TILE_SIZE)
    if self.map.mouse_layer.mouse_layer.get_parent():
        self.map.mouse_layer.mouse_layer.get_parent().remove_child(self.map.mouse_layer.mouse_layer)
    self.map.tiles_ground_anchor.add_child(self.map.mouse_layer.mouse_layer)
    for key in self.map.mouse_layer.ground_points.keys():
        ground_point = self.map.mouse_layer.ground_points[key]
        tile = self.map.model.tiles[key]
        ground_point.bind_ground_for_mouse(self.map, tile.position)


func place_tile(tile_id, tile_data):
    var tile = self.map.model.tiles[tile_id]

    if tile_data["ground"]["tile"] != null:
        self.place_ground(tile.position, tile_data["ground"]["tile"], tile_data["ground"]["rotation"])

    if tile_data["frame"]["tile"] != null:
        self.place_frame(tile.position, tile_data["frame"]["tile"], tile_data["frame"]["rotation"])

    if tile_data["decoration"]["tile"] != null:
        self.place_decoration(tile.position, tile_data["decoration"]["tile"], tile_data["decoration"]["rotation"])

    if tile_data.has("damage") and tile_data["damage"]["tile"] != null:
        self.place_damage(tile.position, tile_data["damage"]["tile"], tile_data["damage"]["rotation"])

    if tile_data["terrain"]["tile"] != null:
        self.place_terrain(tile.position, tile_data["terrain"]["tile"], tile_data["terrain"]["rotation"])

    if tile_data["building"]["tile"] != null:
        self.place_building(tile.position, tile_data["building"]["tile"], tile_data["building"]["rotation"], tile_data["building"]["side"])
        if tile_data["building"].has("abilities"):
            tile.building.tile.restore_abilities_status(tile_data["building"]["abilities"])

    if tile_data["unit"]["tile"] != null:
        if not tile_data["unit"].has("ai_paused"):
            tile_data["unit"]["ai_paused"] = false
        self.place_unit(tile.position, tile_data["unit"]["tile"], tile_data["unit"]["rotation"], tile_data["unit"]["side"], tile_data["unit"]["ai_paused"])


func set_building_side(position, new_side, new_team=null):
    var tile = self.map.model.get_tile(position)

    if tile.building.is_present():
        tile.building.tile.set_side(new_side)
        tile.building.tile.set_team(new_team)
        tile.building.tile.set_side_material(self.map.templates.get_side_material(new_side))

func set_unit_side(position, new_side):
    var tile = self.map.model.get_tile(position)
    if tile.unit.is_present():
        self._set_unit_side(tile.unit.tile, new_side)

func _set_unit_side(unit, new_side):
    var material_type = self.map.templates.MATERIAL_NORMAL
    if unit.uses_metallic_material:
        material_type = self.map.templates.MATERIAL_METALLIC
    unit.set_side(new_side)
    unit.set_side_materials(self.map.templates.get_side_material(new_side, material_type), self.map.templates.get_side_material_desat(new_side, material_type))

func _notify_removal(tile_fragment, position, tile_class, side=null, modifiers={}, double=true):
    if self.editor != null:
        self.editor.notify_about_removal({
            "type" : "remove",
            "class" : tile_class,
            "position" : position,
            "tile" : tile_fragment.tile.template_name,
            "rotation" : tile_fragment.tile.current_rotation,
            "side" : side,
            "modifiers" : modifiers,
            "double" : double
        })

func _disable_shadow(tile):
    if tile.shadow_override and self.map.settings.get_option("shadows"):
        return

    tile.disable_shadow()

func rebuild_tile(tile_id, tile_data):
    var tile = self.map.model.tiles[tile_id]
    tile.wipe()

    self.place_tile(tile_id, tile_data)
    tile.is_state_modified = true
    if tile.unit.is_present():
        tile.unit.tile.restore_from_state(tile_data["unit"])
        if tile_data["unit"].has("passenger"):
            var passenger = self.map.templates.get_template(tile_data["unit"]["passenger"]["tile"])
            passenger.set_rotation(Vector3(0, deg_to_rad(tile_data["unit"]["passenger"]["rotation"]), 0))
            passenger.current_rotation = tile_data["unit"]["passenger"]["rotation"]
            if not self.map.settings.get_option("shadows"):
                self._disable_shadow(passenger)
            passenger.restore_from_state(tile_data["unit"]["passenger"])
            self._set_unit_side(passenger, tile_data["unit"]["passenger"]["side"])

            tile.unit.tile.passenger = passenger
