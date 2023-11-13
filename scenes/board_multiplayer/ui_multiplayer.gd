extends Control

@onready var announcement_label = $"announcement"

func set_announcement(announcement):
	self.announcement_label.set_text(announcement)
	self.announcement_label.show()

func clear_announcement():
	self.announcement_label.hide()
