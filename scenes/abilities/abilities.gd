
var board

func _init(_board):
    self.board = _board

func execute_ability(ability, context_object=null):
    if ability.TYPE == "production":
        ability.execute(self.board, context_object.position)
