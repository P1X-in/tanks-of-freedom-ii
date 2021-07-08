extends Control

onready var radial = $"radial/radial"
onready var resource = $"resources/coin_view"
onready var resource_label = $"resources/coin_view/label"
onready var summary = $"summary/summary_view"
onready var end_turn = $"end_turn/end_turn"
onready var start_turn = $"start_turn/start_turn"
onready var story_dialog = $"story_dialog/story_dialog"
onready var cinematic_bars = $"cinematic_bars/cinematic_bars"

onready var tile_highlight = $"tile_highlight/tile_view"
onready var tile_highlight_unit_panel_hp = $"tile_highlight/tile_view/hp"

var icons = preload("res://scenes/ui/icons/icons.gd").new()

func is_popup_open():
    if self.summary.is_visible():
        return true

    if self.story_dialog.is_visible():
        return true

    return false

func is_panel_open():
    if self.is_radial_open():
        return true
    if self.is_popup_open():
        return true

    return false

func is_radial_open():
    return self.radial.is_visible()

func show_radial():
    self.radial.show_menu()

func hide_radial():
    self.radial.hide_menu()

func toggle_radial():
    if self.radial.is_visible():
        self.hide_radial()
    else:
        self.show_radial()

func update_resource_value(value):
    self.resource_label.set_text(str(value))

func update_tile_highlight(tile_preview):
    if self.cinematic_bars.is_extended:
        return

    self.clear_tile_highlight()
    self.tile_highlight.show()
    self.tile_highlight.set_tile(tile_preview, 0)

func update_tile_highlight_unit_panel(unit):
    self.tile_highlight_unit_panel_hp.set_text(str(unit.hp) + "/" + str(unit.max_hp))

func update_tile_highlight_building_panel(ap_gain):
    self.tile_highlight_unit_panel_hp.set_text("+" + str(ap_gain))

func hide_resource():
    self.resource.hide()

func clear_tile_highlight():
    self.tile_highlight.clear()
    self.tile_highlight.hide()
    self.tile_highlight_unit_panel_hp.set_text("")

func show_summary(winner):
    self.summary.show()
    self.summary.configure_winner(winner)

func show_end_turn():
    self.end_turn.show()

func hide_end_turn():
    self.end_turn.hide()
    self.end_turn.reset()

func update_end_turn_progress(value):
    self.end_turn.set_progress(value)

func flash_start_end_card(player, turn):
    self.start_turn.flash(player, turn)

func show_story_dialog(text, actor):
    self.story_dialog.set_text(text)
    self.story_dialog.set_actor(actor)
    self.story_dialog.show_panel()

func hide_story_dialog():
    self.story_dialog.hide()

func show_cinematic_bars():
    self.clear_tile_highlight()
    self.cinematic_bars.show_bars()

func hide_cinematic_bars():
    self.cinematic_bars.hide_bars()

func are_cinematic_bars_visible():
    return self.cinematic_bars.is_extended
