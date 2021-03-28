extends "res://scenes/board/logic/scripting/triggers/base_trigger.gd"

var building = null
var building_type = null

func observe(event):
    if self.building != null and event.building == self.building:
        self.execute_outcome(event)
    elif self.building_type != null and event.building.template_name == self.building_type:
        self.execute_outcome(event)
        

func execute_outcome(event):
    var metadata = {}
    metadata['old_side'] = event.old_side
    metadata['new_side'] = event.new_side

    self.outcome.execute(metadata)

