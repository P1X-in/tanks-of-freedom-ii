class_name Events

var types = load("res://scenes/board/logic/events/types.gd").new()

var event_templates = {
	self.types.BUILDING_CAPTURED : load("res://scenes/board/logic/events/building_captured.gd"),
	self.types.UNIT_SPAWNED : load("res://scenes/board/logic/events/unit_spawned.gd"),
	self.types.UNIT_MOVED : load("res://scenes/board/logic/events/unit_moved.gd"),
	self.types.UNIT_ATTACKED : load("res://scenes/board/logic/events/unit_attacked.gd"),
	self.types.UNIT_DESTROYED : load("res://scenes/board/logic/events/unit_destroyed.gd"),
	self.types.TURN_STARTED : load("res://scenes/board/logic/events/turn_started.gd"),
	self.types.ABILITY_USED : load("res://scenes/board/logic/events/ability_used.gd")
}

var observers = {}

func get_new_event(type):
	if not self.event_templates.has(type):
		return null

	var new_event = self.event_templates[type].new(type)
	return new_event

func register_observer(event_type, observer_object, observer_method):
	if not self.observers.has(event_type):
		self.observers[event_type] = []

	self.observers[event_type].append({
		'observer_object' : observer_object,
		'observer_method' : observer_method
	})

func emit_event(event_object):
	if self.observers.has(event_object.type):
		for observer in self.observers[event_object.type]:
			if observer['observer_object'].suspended:
				continue
			observer['observer_object'].call(observer['observer_method'], event_object)


func emit_building_captured(building, old_side, new_side):
	var event = self.get_new_event(self.types.BUILDING_CAPTURED)
	event.building = building
	event.old_side = old_side
	event.new_side = new_side
	self.emit_event(event)

func emit_unit_attacked(attacker, defender):
	var event = self.get_new_event(self.types.UNIT_ATTACKED)
	event.unit = defender
	event.attacker = attacker
	self.emit_event(event)

func emit_unit_destroyed(attacker, defender_id, defender_type, defender_side):
	var event = self.get_new_event(self.types.UNIT_DESTROYED)
	event.unit_id = defender_id
	event.unit_side = defender_side
	event.unit_type = defender_type
	event.attacker = attacker
	self.emit_event(event)

func emit_unit_spawned(source, unit):
	var event = self.get_new_event(self.types.UNIT_SPAWNED)
	event.source = source
	event.unit = unit
	self.emit_event(event)

func emit_ability_used(ability, target):
	var event = self.get_new_event(self.types.ABILITY_USED)
	event.ability = ability
	event.target = target
	self.emit_event(event)

func emit_turn_started(turn_no, player_id):
	var event = self.get_new_event(self.types.TURN_STARTED)
	event.turn_no = turn_no
	event.player_id = player_id
	self.emit_event(event)

func emit_unit_moved(unit, start, finish):
	var event = self.get_new_event(self.types.UNIT_MOVED)
	event.unit = unit
	event.start = start
	event.finish = finish
	self.emit_event(event)
