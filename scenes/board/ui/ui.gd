extends Control

# Panels
onready var radial = $"radial/radial"
onready var resource = $"resources/coin_view"
onready var resource_label = $"resources/coin_view/label"
onready var summary = $"summary/summary_view"
onready var end_turn = $"end_turn/end_turn"
onready var start_turn = $"start_turn/start_turn"
onready var story_dialog = $"story_dialog/story_dialog"
onready var cinematic_bars = $"cinematic_bars/cinematic_bars"
onready var unit_stats = $"unit_stats/unit_stats"
onready var objectives = $"objectives/objectives"

# Tile highlight
onready var tile_highlight = $"tile_highlight/tile_view"
onready var tile_highlight_level1 = $"tile_highlight/level1"
onready var tile_highlight_level2 = $"tile_highlight/level2"
onready var tile_highlight_level3 = $"tile_highlight/level3"
onready var tile_highlight_unit_panel_hp = $"tile_highlight/tile_view/hp"

# Tile highlight abilities
onready var ab1 = $"tile_highlight/abilities/ab1"
onready var ab1_anchor = $"tile_highlight/abilities/ab1/anchor"
onready var ab1_name = $"tile_highlight/abilities/ab1/label"
onready var ab1_disabled = $"tile_highlight/abilities/ab1/disabled"
onready var ab1_cd = $"tile_highlight/abilities/ab1/disabled/cd"
onready var ab2 = $"tile_highlight/abilities/ab2"
onready var ab2_anchor = $"tile_highlight/abilities/ab2/anchor"
onready var ab2_name = $"tile_highlight/abilities/ab2/label"
onready var ab2_disabled = $"tile_highlight/abilities/ab2/disabled"
onready var ab2_cd = $"tile_highlight/abilities/ab2/disabled/cd"
onready var ab3 = $"tile_highlight/abilities/ab3"
onready var ab3_anchor = $"tile_highlight/abilities/ab3/anchor"
onready var ab3_name = $"tile_highlight/abilities/ab3/label"
onready var ab3_disabled = $"tile_highlight/abilities/ab3/disabled"
onready var ab3_cd = $"tile_highlight/abilities/ab3/disabled/cd"
var ability_icons = [null, null, null]

var icons = preload("res://scenes/ui/icons/icons.gd").new()

func is_popup_open():
    if self.summary.is_visible():
        return true

    if self.story_dialog.is_visible():
        return true

    if self.unit_stats.is_visible():
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
    self.clear_tile_highlight()
    if self.cinematic_bars.is_extended:
        return

    self.tile_highlight.show()
    self.tile_highlight.set_tile(tile_preview, 0)

func update_tile_highlight_unit_panel(unit, board):
    if self.cinematic_bars.is_extended:
        return
    self.tile_highlight_unit_panel_hp.set_text(str(unit.hp) + "/" + str(unit.max_hp))

    match unit.level:
        1:
            self.tile_highlight_level1.show()
        2:
            self.tile_highlight_level2.show()
        3:
            self.tile_highlight_level3.show()
    self._show_active_abilities(unit, board)

func _show_active_abilities(unit, board):
    if not unit.has_active_ability():
        return

    var index = 0

    for ability in unit.active_abilities:
        if ability.is_visible(board):
            if index > 2:
                return
            self._bind_ability(index, ability)
            index += 1

func _bind_ability(index, ability):
    var boxes = [
        self.ab1,
        self.ab2,
        self.ab3
    ]
    var anchors = [
        self.ab1_anchor,
        self.ab2_anchor,
        self.ab3_anchor,
    ]
    var labels = [
        self.ab1_name,
        self.ab2_name,
        self.ab3_name,
    ]
    var disabled = [
        self.ab1_disabled,
        self.ab2_disabled,
        self.ab3_disabled,
    ]
    var cooldowns = [
        self.ab1_cd,
        self.ab2_cd,
        self.ab3_cd,
    ]

    boxes[index].show()
    var icon = self.icons.get_named_icon(ability.named_icon)
    if icon != null:
        anchors[index].add_child(icon)
    self.ability_icons[index] = icon
    labels[index].set_text(ability.label)

    if ability.cd_turns_left > 0:
        disabled[index].show()
        cooldowns[index].set_text(str(ability.cd_turns_left))
    else:
        disabled[index].hide()

func update_tile_highlight_building_panel(ap_gain):
    self.tile_highlight_unit_panel_hp.set_text("+" + str(ap_gain))

func hide_resource():
    self.resource.hide()

func clear_tile_highlight():
    self.tile_highlight.clear()
    self.tile_highlight.hide()
    self.tile_highlight_level1.hide()
    self.tile_highlight_level2.hide()
    self.tile_highlight_level3.hide()
    self.tile_highlight_unit_panel_hp.set_text("")
    self.ab1.hide()
    self.ab2.hide()
    self.ab3.hide()

    if self.ability_icons[0] != null:
        self.ability_icons[0].queue_free()
    if self.ability_icons[1] != null:
        self.ability_icons[1].queue_free()
    if self.ability_icons[2] != null:
        self.ability_icons[2].queue_free()
    self.ability_icons = [null, null, null]

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

func show_unit_stats(unit, tile_preview, board):
    self.unit_stats.bind_unit(unit, tile_preview, board)
    self.unit_stats.show_panel()

func hide_unit_stats():
    self.unit_stats.hide()

func show_objectives():
    self.objectives.show()

func hide_objectives():
    self.objectives.hide()
