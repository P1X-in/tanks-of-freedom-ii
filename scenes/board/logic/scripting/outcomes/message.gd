extends "res://scenes/board/logic/scripting/outcomes/base_outcome.gd"

var text
var portrait = null
var name
var side = "left"
var colour = null

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

		actor['portrait_tile'].set_side_materials(self.board.map.templates.get_side_material(self.colour, material_type), self.board.map.templates.get_side_material_desat(self.colour, material_type))

	self.board.ui.show_story_dialog(text, actor)

func _ingest_details(details):
	self.text = details['text']
	if details.has("portrait"):
		self.portrait = details['portrait']
	self.name = details['name']
	if details.has("side"):
		self.side = details['side']
	if details.has("colour"):
		self.colour = details['colour']
