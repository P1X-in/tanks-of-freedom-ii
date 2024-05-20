extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var text
var portrait = null
var name
var side = "left"
var colour = null
var font_size = 16
var sound = null

func _execute(_metadata):
	var actor = {
		'portrait' : self.portrait,
		'portrait_tile' : self.board.map.templates.get_template(self.portrait),
		'name' : self.name,
		'side' : self.side
	}

	actor['portrait_tile'].tile_view_height_cam_modifier = -0.2

	if self.colour != null:
		var material_type = self.board.map.templates.MATERIAL_NORMAL
		if actor['portrait_tile'].uses_metallic_material:
			material_type = self.board.map.templates.MATERIAL_METALLIC

		actor['portrait_tile'].set_side_materials(self.board.map.templates.get_side_material(self.colour, material_type), self.board.map.templates.get_side_material(self.colour, material_type))

	self.board.ui.show_story_dialog(text, actor, self.font_size)

	if self.sound != null:
		self.board.audio.play(self.sound)

func _ingest_details(details):
	self.name = details['name']
	if details.has("portrait"):
		self.portrait = details['portrait']
	if details.has("side"):
		self.side = details['side']
	if details.has("colour"):
		self.colour = details['colour']
	if details.has("font_size"):
		self.font_size = details['font_size']
	if details.has("sound"):
		self.sound = details['sound']
	self.text = details['text']
