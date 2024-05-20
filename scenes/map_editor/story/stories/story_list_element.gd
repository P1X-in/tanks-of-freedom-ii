extends Control

signal edit_requested(story_name)
signal story_removal_requested(story_name)

var story_name = null

func set_story_name(new_story_name):
	self.story_name = new_story_name
	$"Label".set_text(new_story_name)


func _on_edit_button_pressed():
	self.edit_requested.emit(self.story_name)


func _on_delete_button_pressed():
	self.story_removal_requested.emit(self.story_name)
