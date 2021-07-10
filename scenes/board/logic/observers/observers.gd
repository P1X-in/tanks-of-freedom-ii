
var board
var basic_observers = [
    preload("res://scenes/board/logic/observers/experience.gd"),
    preload("res://scenes/board/logic/observers/hero_spawn.gd"),
]

func _init(_board):
    self.board = _board
    self._register_basic_observers()

func _register_basic_observers():
    var observer

    for template in self.basic_observers:
        observer = template.new(self.board)
        
        for event_type in observer.observed_event_type:
            self.board.events.register_observer(event_type, observer, 'observe')
