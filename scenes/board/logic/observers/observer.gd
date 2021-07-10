
var board = null
var suspended = false
var observed_event_type = [null]

func _init(_board):
    self.board = _board

func observe(event):
    if self.suspended:
        return

    self._observe(event)
    
func _observe(_event):
    return

func activate():
    self.suspended = false

func deactivate():
    self.suspended = true
