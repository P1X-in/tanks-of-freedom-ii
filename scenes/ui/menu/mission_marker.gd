extends Control

onready var animations = $"animations"

var main_menu

func bind_menu(menu):
    self.main_menu = menu

func show_panel():
    self.animations.play("show")

func hide_panel():
    self.animations.play("hide")

func set_mission_title(mission_no, title):
    $"label/background/mission_name".set_text(str(mission_no) + ". " + title)

func set_complete():
    $"flag".hide()
    $"flag_complete".show()
