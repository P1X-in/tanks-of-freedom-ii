extends "res://scenes/tiles/units/unit.gd"

var disable_active_abilities = false

func register_ability(ability):
    if ability.TYPE == "hero_passive":
        self.passive_ability = ability
    if ability.TYPE == "hero_active":
        self.active_abilities.append(ability)

    super.register_ability(ability)


func has_active_ability():
    if self.disable_active_abilities:
        return false

    return self.active_abilities.size() > 0

func has_passive_ability():
    return self.passive_ability != null

func disable_abilities():
    self.disable_active_abilities = true

func enable_abilities():
    self.disable_active_abilities = false

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

func get_dict():
    var new_dict = super.get_dict()
    new_dict["disable_active_abilities"] = self.disable_active_abilities

    return new_dict

func restore_from_state(state):
    super.restore_from_state(state)
    self.disable_active_abilities = state["disable_active_abilities"]

func is_hero():
    return true
