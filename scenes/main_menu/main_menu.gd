extends Spatial

onready var map = $"map"
onready var ui = $"ui"
onready var audio = $"/root/SimpleAudioLibrary"
onready var switcher = $"/root/SceneSwitcher"
onready var gamepad_adapter = $"/root/GamepadAdapter"
onready var match_setup = $"/root/MatchSetup"

func _ready():
    self.map.loader.load_map_file("main_menu_bg", "bundle")
    self._setup_camera()
    self.map.hide_tile_box()
    self.audio.track("menu")
    self.gamepad_adapter.enable()
    self.ui.bind_menu(self)

    if self.match_setup.campaign_win:
        self.reopen_campaign_mission_selection_after_win()

func _setup_camera():
    self.map.camera.paused = true

    self.map.camera.set_translation(Vector3(220, 4.05, 196))
    self.map.camera.camera_mode = self.map.camera.MODE_FREE
    self.map.camera.camera_lens.make_current()
    self.map.camera.camera_lens.set_translation(Vector3(0, 0, 20))
    self.map.camera.camera_pivot.set_rotation_degrees(Vector3(0, 0, 0))
    self.map.camera.camera_arm.set_rotation_degrees(Vector3(-20, 0, 0))

func open_picker():
    self.ui.hide_menu()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_picker()

    self.ui.picker.bind_cancel(self, "close_picker")
    self.ui.picker.bind_success(self, "handle_picker_output")
    self.ui.picker.set_select_mode()

func close_picker():
    self.ui.hide_picker()
    self.gamepad_adapter.enable()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_menu()

func handle_picker_output(args):
    self.ui.hide_picker()
    self.gamepad_adapter.enable()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_skirmish(args[0])

func close_skirmish():
    self.ui.hide_skirmish()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_picker()

func open_settings():
    self.ui.hide_menu()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_settings()

func close_settings():
    self.ui.hide_settings()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_menu()

func open_campaign_selection():
    self.ui.hide_menu()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_campaign_selection(true)

func close_campaign_selection():
    self.ui.hide_campaign_selection()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_menu()

func open_campaign_mission_selection(campaign_name=null):
    self.ui.hide_campaign_selection()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_campaign_mission_selection(campaign_name)

func close_campaign_mission_selection():
    self.ui.hide_campaign_mission_selection()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_campaign_selection()

func open_campaign_mission(campaign_name, mission_no):
    self.ui.hide_campaign_mission_selection()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_campaign_mission(campaign_name, mission_no)

func close_campaign_mission():
    self.ui.hide_campaign_mission()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_campaign_mission_selection()

func reopen_campaign_mission_selection_after_win():
    self.match_setup.campaign_win = false
    self.ui.hide_menu()
    self.ui.campaign_selection.show_first_page()
    yield(self.get_tree().create_timer(0.2), "timeout")
    self.ui.show_campaign_mission_selection(self.match_setup.campaign_name)
