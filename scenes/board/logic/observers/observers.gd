class_name Observers

var board:GameBoard
var basic_observers = [
	load("res://scenes/board/logic/observers/experience.gd"),
	load("res://scenes/board/logic/observers/hero_spawn.gd"),
]

func _init(_board:GameBoard):
	self.board = _board
	self._register_basic_observers()

func _register_basic_observers():
	var observer

	for template in self.basic_observers:
		observer = template.new(self.board)
		
		for event_type in observer.observed_event_type:
			self.board.events.register_observer(event_type, observer, 'observe')
