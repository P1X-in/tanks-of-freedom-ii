
var types = preload("res://scenes/board/logic/events/types.gd").new()

var event_templates = {
    self.types.BUILDING_CAPTURED : preload("res://scenes/board/logic/events/building_captured.gd"),
    self.types.UNIT_SPAWNED : preload("res://scenes/board/logic/events/unit_spawned.gd"),
    self.types.UNIT_MOVED : preload("res://scenes/board/logic/events/unit_moved.gd"),
    self.types.UNIT_ATTACKED : preload("res://scenes/board/logic/events/unit_attacked.gd"),
    self.types.UNIT_DESTROYED : preload("res://scenes/board/logic/events/unit_destroyed.gd"),
    self.types.TURN_STARTED : preload("res://scenes/board/logic/events/turn_started.gd"),
    self.types.ABILITY_USED : preload("res://scenes/board/logic/events/ability_used.gd")
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
