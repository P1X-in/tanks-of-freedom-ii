
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

func _get_passive_for_source(source):
    var hero = self.board.state.get_hero_for_side(source.side)
    
    if hero == null:
        return null
    
    if not hero.has_passive_ability():
        return null

    return hero.passive_ability
