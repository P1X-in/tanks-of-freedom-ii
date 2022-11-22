extends Control

const SIZE_MARGIN = 20
const CHAR_SIZE = 11

onready var animations = $"animations"

var main_menu

func bind_menu(menu):
    self.main_menu = menu

func show_panel():
    self.animations.play("show")

func hide_panel():
    self.animations.play("hide")

func set_mission_title(mission_no, title):
    var label_text = str(mission_no) + ". " + tr(title)
    $"label/background/mission_name".set_text(label_text)
    var box = $"label/background"
    var size = box.get_size()
    size.x = label_text.length() * self.CHAR_SIZE + self.SIZE_MARGIN
    box.set_size(size)


func set_complete():
    $"flag".hide()
    $"flag_complete".show()
