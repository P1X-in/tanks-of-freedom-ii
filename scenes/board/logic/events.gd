
var types = preload("res://scenes/board/logic/events/types.gd").new()

var event_templates = {
    self.types.BUILDING_CAPTURED : preload("res://scenes/board/logic/events/building_captured.gd")
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
            observer['observer_object'].call(observer['observer_method'], event_object)
