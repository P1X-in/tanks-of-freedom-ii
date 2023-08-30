extends Node2D

@onready var level1 = $"background/level1"
@onready var level2 = $"background/level2"
@onready var level3 = $"background/level3"
@onready var tile_highlight = $"background/tile_view"

@onready var unit_name = $"background/unit_name"
@onready var hp_value = $"background/hp_label/hp_value"
@onready var armour_value = $"background/armour_label/armour_value"
@onready var ap_value = $"background/ap_label/ap_value"
@onready var attack_value = $"background/attack_label/attack_value"
@onready var level_value = $"background/level_label/level_value"
@onready var kills_value = $"background/kills_label/kills_value"

@onready var ab1 = $"background/abilities/ab1"
@onready var ab1_anchor = $"background/abilities/ab1/anchor"
@onready var ab1_name = $"background/abilities/ab1/label"
@onready var ab1_desc = $"background/abilities/ab1/description"
@onready var ab2 = $"background/abilities/ab2"
@onready var ab2_anchor = $"background/abilities/ab2/anchor"
@onready var ab2_name = $"background/abilities/ab2/label"
@onready var ab2_desc = $"background/abilities/ab2/description"
@onready var ab3 = $"background/abilities/ab3"
@onready var ab3_anchor = $"background/abilities/ab3/anchor"
@onready var ab3_name = $"background/abilities/ab3/label"
@onready var ab3_desc = $"background/abilities/ab3/description"

@onready var passive_panel = $"background/passive"
@onready var passive_name = $"background/passive/label"
@onready var passive_desc = $"background/passive/description"

@onready var back_button = $"back_button"

@onready var audio = $"/root/SimpleAudioLibrary"

var icons = [null, null, null]

func show_panel():
    self.show()
    self.call_deferred("_back_grab_focus")

func reset_view():
    self.level1.hide()
    self.level2.hide()
    self.level3.hide()
    self.ab1.hide()
    self.ab2.hide()
    self.ab3.hide()
    self.passive_panel.hide()
    self.tile_highlight.clear()

    if self.icons[0] != null:
        self.icons[0].queue_free()
    if self.icons[1] != null:
        self.icons[1].queue_free()
    if self.icons[2] != null:
        self.icons[2].queue_free()
    self.icons = [null, null, null]


func bind_unit(unit, tile_preview, board):
    self.reset_view()

    var stats = unit.get_stats_with_modifiers()

    self.tile_highlight.set_tile(tile_preview, 0)
    self.unit_name.set_text(unit.unit_name)
    self.hp_value.set_text(str(stats['hp']) + "/" + str(stats['max_hp']))
    self.armour_value.set_text(str(stats['armor']))
    self.ap_value.set_text(str(unit.move) + "/" + str(stats['max_move']))
    self.attack_value.set_text(str(stats['attack']))
    self.level_value.set_text(str(unit.level))
    self.kills_value.set_text(str(unit.kills))

    match unit.level:
        1:
            self.level1.show()
        2:
            self.level2.show()
        3:
            self.level3.show()
    self.show_active_abilities(unit, board)
    self.show_passive_ability(unit)

func show_active_abilities(unit, board):
    if not unit.has_active_ability():
        return

    var index = 0

    for ability in unit.active_abilities:
        if ability.is_visible(board):
            if index > 2:
                return
            self.bind_ability(index, ability, board)
            index += 1

func bind_ability(index, ability, board):
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
    var descs = [
        self.ab1_desc,
        self.ab2_desc,
        self.ab3_desc,
    ]

    boxes[index].show()
    var icon = board.ui.icons.get_named_icon(ability.named_icon)
    if icon != null:
        anchors[index].add_child(icon)
    self.icons[index] = icon
    labels[index].set_text(tr(ability.label))
    descs[index].set_text(ability.description)

func show_passive_ability(unit):
    if unit.passive_ability != null:
        self.passive_name.set_text(unit.passive_ability.label)
        self.passive_desc.set_text(unit.passive_ability.description)
        self.passive_panel.show()

func _back_grab_focus():
    self.back_button.grab_focus()

func _on_back_button_pressed():
    self.hide()
    self.audio.play("menu_back")
