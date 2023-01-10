
var board = null
var outcome = null
var suspended = false
var observed_event_type = [null]
var one_off = false

func observe(event):
    if self.suspended:
        return

    self._observe(event)
    
func _observe(_event):
    return

func execute_outcome(event):
    self._execute_outcome(event)
    if self.one_off:
        self.deactivate()

func _execute_outcome(event):
    self.outcome.execute(self._get_outcome_metadata(event))

func _get_outcome_metadata(_event):
    return {}

func ingest_details(_details):
    return

func activate():
    self.suspended = false

func deactivate():
    self.suspended = true

func get_save_data():
    return {
        "suspended": self.suspended
    }
