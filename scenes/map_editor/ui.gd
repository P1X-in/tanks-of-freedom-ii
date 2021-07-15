extends Control

onready var radial = $"radial/radial"
onready var picker = $"picker/picker"
onready var minimap = $"minimap"
onready var minimap_animations = $"minimap/animations"

onready var position_label = $"position/label"
onready var map_name_wrapper = $"map_name"
onready var map_name_label = $"map_name/inner/label"

onready var tile_animations = $"tile/animations"
onready var tile_prev = $"tile/wrapper/tile_view_prev"
onready var tile_current = $"tile/wrapper/tile_view_current"
onready var tile_next = $"tile/wrapper/tile_view_next"
onready var type_prev = $"tile/wrapper/tile_type_prev"
onready var type_next = $"tile/wrapper/tile_type_next"

var icons = preload("res://scenes/ui/icons/icons.gd").new()

func update_position(x, y):
    self.position_label.set_text("[" + str(x) + ", " + str(y) + "]")

func set_tile_prev(tile, rotation):
    self.tile_prev.set_tile(tile, rotation)

func set_tile_current(tile, rotation):
    self.tile_current.set_tile(tile, rotation)

func set_tile_next(tile, rotation):
    self.tile_next.set_tile(tile, rotation)

func set_type_prev(tile, rotation):
    self.type_prev.set_tile(tile, rotation)

func set_type_next(tile, rotation):
    self.type_next.set_tile(tile, rotation)

func toggle_radial():
    if self.radial.is_visible():
        self.hide_radial()
        self.show_tiles()
        self.show_position()
    else:
        self.show_radial()
        self.hide_tiles()
        self.hide_position()


func show_tiles():
    self.tile_animations.play("show")
    self.minimap_animations.play("show")
    if self.map_name_label.get_text() != "":
        self.map_name_wrapper.show()

func hide_tiles():
    self.tile_animations.play("hide")
    self.minimap_animations.play("hide")
    self.map_name_wrapper.hide()

func show_radial():
    self.radial.show_menu()

func hide_radial():
    self.radial.hide_menu()

func show_picker():
    self.picker.show_picker()

func hide_picker():
    self.picker.hide_picker()

func show_position():
    self.position_label.show()

func hide_position():
    self.position_label.hide()

func close_all_popups():
    if self.picker.is_visible():
        self.hide_picker()

func is_radial_open():
    return self.radial.is_visible()
    
func is_popup_open():
    if self.picker.is_visible():
        return true

    return false

func is_panel_open():
    if self.radial.is_visible():
        return true
    if self.is_popup_open():
        return true

    return false

func set_map_name(name, skip_show=false):
    self.map_name_label.set_text(name)
    self.picker.set_map_name(name)

    if name != "" and not skip_show:
        self.map_name_wrapper.show()
    else:
        self.map_name_wrapper.hide()

func load_minimap(map_name):
    self.minimap.remove_from_cache(map_name)
    self.minimap.fill_minimap(map_name)

func wipe_minimap():
    self.minimap.wipe()
    
