
var board

func _init(_board):
    self.board = _board

func execute_ability(ability, context_object=null):
    ability.execute(self.board, context_object.position)

func get_modified_cost(cost, template_name, source):
    var passive_ability = self._get_passive_for_source(source)
    
    if passive_ability == null:
        return cost

    return passive_ability.get_modified_cost(cost, template_name)

func get_modified_cooldown(cd_value, source):
    var passive_ability = self._get_passive_for_source(source)
    
    if passive_ability == null:
        return cd_value

    return passive_ability.get_modified_cooldown(cd_value)


func get_modified_ap_gain(value, source):
    var passive_ability = self._get_passive_for_source(source)
    
    if passive_ability == null:
        return value

    return passive_ability.get_modified_ap_gain(value, source.template_name)

func get_initial_level(template_name, source):
    var passive_ability = self._get_passive_for_source(source)
    
    if passive_ability == null:
        return 0

    return passive_ability.get_initial_level(template_name)

func apply_passive_modifiers(unit):
    var passive_ability = self._get_passive_for_source(unit)
    
    if passive_ability == null:
        return

    var modifiers = passive_ability.get_passive_modifiers(unit.template_name)
    for modifier_name in modifiers:
        unit.apply_modifier(modifier_name, modifiers[modifier_name])

func can_intimidate_crew(source):
    var passive_ability = self._get_passive_for_source(source)
    
    if passive_ability == null:
        return false

    return passive_ability.can_intimidate_crew()

func _get_passive_for_source(source):
    if source.side == "neutral":
        return null

    var hero = self.board.state.get_hero_for_side(source.side)
    
    if hero == null:
        return null
    
    if not hero.has_passive_ability():
        return null

    return hero.passive_ability
