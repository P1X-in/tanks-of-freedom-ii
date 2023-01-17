extends "res://scenes/ui/menu/base_menu_panel.gd"

onready var online = $"/root/Online"

onready var back_button = $"widgets/back_button"

onready var register_panel = $"widgets/register"
onready var register_button = $"widgets/register/register_button"
onready var register_description = $"widgets/register/description"

onready var online_panel = $"widgets/online"

var working = false

func _on_back_button_pressed():
    if self.working:
        return
    self.audio.play("menu_back")
    self.main_menu.close_online()

func _on_register_button_pressed():
    if self.working:
        return

    self.working = true
    self.audio.play("menu_click")
    self.register_description.set_text(tr("TR_REQUESTING_PLAYER_ID"))
    self.register_button.hide()
    self.back_button.hide()

    var result = self.online.request_player_id()
    if result is GDScriptFunctionState:
        result = yield(result, "completed")

    self.working = false
    if result == "ok":
        self.register_description.set_text(tr("TR_REQUESTING_PLAYER_SUCCESS"))
        yield(self.get_tree().create_timer(2), "timeout")
        self._select_panel()
    else:
        self.back_button.show()
        self.register_button.show()
        self.register_description.set_text(tr("TR_REQUESTING_PLAYER_FAIL"))
        yield(self.get_tree().create_timer(0.1), "timeout")
        self.register_button.grab_focus()




func show_panel():
    .show_panel()
    self._select_panel()

func _select_panel():
    self.back_button.show()
    if self.online.is_integrated():
        self.online_panel.show()
        self.register_panel.hide()
    else:
        self.online_panel.hide()
        self.register_panel.show()
        self.register_button.show()
        self.register_description.set_text(tr("TR_NEED_REGISTER"))

        yield(self.get_tree().create_timer(0.1), "timeout")
        self.register_button.grab_focus()
