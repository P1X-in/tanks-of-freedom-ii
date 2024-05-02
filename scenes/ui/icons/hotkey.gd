@tool
extends Sprite2D

@export var keyboard_frame:int:
	set(val):
		keyboard_frame = val
		if Engine.is_editor_hint():
			region_rect = get_atlas_rect(keyboard_frame, keyboard_cell_size)
		else:
			_update_icon()
@export var keyboard_cell_size:Vector2 = Vector2(1,1):
	set(val):
		keyboard_cell_size = val
		if Engine.is_editor_hint():
			region_rect = get_atlas_rect(keyboard_frame, keyboard_cell_size)
		else:
			_update_icon()
@export var gamepad_frame:int:
	set(val):
		gamepad_frame = val
		if Engine.is_editor_hint():
			region_rect = get_atlas_rect(gamepad_frame, gamepad_cell_size)
		else:
			_update_icon()
@export var gamepad_cell_size:Vector2 = Vector2(1,1):
	set(val):
		gamepad_cell_size = val
		if Engine.is_editor_hint():
			region_rect = get_atlas_rect(gamepad_frame, gamepad_cell_size)
		else:
			_update_icon()


const atlas_params := {
	atlas_size = Vector2(34, 24),
}

func _ready() -> void:
	if Engine.is_editor_hint():
		region_rect = get_atlas_rect(keyboard_frame, keyboard_cell_size)
		return
	ButtonHotkeyService.mode_changed.connect(_update_icon)
	_update_icon()

func _update_icon():
	match ButtonHotkeyService.current_mode:
		ButtonHotkeyService.MODE.KEYBOARD:
			region_rect = get_atlas_rect(keyboard_frame, keyboard_cell_size)
		ButtonHotkeyService.MODE.GAMEPAD:
			region_rect = get_atlas_rect(gamepad_frame, gamepad_cell_size)

func get_atlas_rect(atlas_frame:int, size:Vector2 = Vector2(1,1)):
	var altasCellSize = texture.get_size() / atlas_params.atlas_size
	var hframe :float = atlas_frame % int(atlas_params.atlas_size.x)
	var vframe :float = floorf(float(atlas_frame) / atlas_params.atlas_size.x)
	return Rect2(altasCellSize*Vector2(hframe, vframe), altasCellSize*size)
