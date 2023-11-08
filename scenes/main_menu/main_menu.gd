extends Node3D

@onready var map = $"map"
@onready var ui = $"ui"
@onready var cart = $"map/path/cart"
@onready var animations = $"animations"
@onready var audio = $"/root/SimpleAudioLibrary"
@onready var switcher = $"/root/SceneSwitcher"
@onready var gamepad_adapter = $"/root/GamepadAdapter"
@onready var match_setup = $"/root/MatchSetup"
@onready var campaign = $"/root/Campaign"
@onready var settings = $"/root/Settings"

const MENU_TIMEOUT = 0.2

var camera_reparented = false

func _ready():
	self.map.loader.load_map_file("main_menu_bg")
	self._setup_camera()
	self.map.hide_tile_box()

	self.audio.master_switch = true
	self.gamepad_adapter.enable()
	self.ui.bind_menu(self)

	if not self.switcher.intro_played and self.settings.get_option("show_intro"):
		self.call_deferred("_start_intro")
	else:
		self.call_deferred("_intro_finished")


func _setup_camera():
	self.map.camera.paused = true

	self.map.camera.set_position(Vector3(220, 4.05, 196))
	self.map.camera.camera_mode = self.map.camera.MODE_FREE
	self.map.camera.camera_lens.make_current()
	self.map.camera.camera_lens.set_position(Vector3(0, 0, 20))
	self.map.camera.camera_pivot.set_rotation_degrees(Vector3(0, 0, 0))
	self.map.camera.camera_arm.set_rotation_degrees(Vector3(-20, 0, 0))


func _start_intro():
	self.switcher.intro_played = true
	$"ui/logo".hide()
	if not self.camera_reparented:
		self.camera_reparented = true
		self.map.remove_child(self.map.camera)
		self.cart.add_child(self.map.camera)
		self.map.camera.set_position(Vector3(0, 0, 0))
		#self.map.camera.camera_pivot.set_rotation_degrees(Vector3(0, 180, 0))
		self.map.camera.camera_lens.set_fov(90)
	if self.settings.get_option("is_steamdeck"):
		await self.get_tree().create_timer(1).timeout
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.audio.track("intro")
	self.animations.play("path")
	self.map.camera.animations.play("fov")

func _camera_arrived():
	pass

func _intro_music_finished():
	self.audio.stop()

func _intro_finished():
	self.switcher.intro_played = true
	$"ui/logo".show()
	self.audio.track("menu")
	if not self.match_setup.campaign_win:
		self.ui.show_menu()

	if self.match_setup.campaign_win:
		self.reopen_campaign_mission_selection_after_win()

func open_picker():
	self.ui.hide_menu()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.picker.set_select_mode()
	self.ui.show_picker()

	self.ui.picker.bind_cancel(self, "close_picker")
	self.ui.picker.bind_success(self, "handle_picker_output")

func close_picker():
	self.ui.hide_picker()
	self.gamepad_adapter.enable()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_menu()

func handle_picker_output(args):
	self.ui.hide_picker()
	self.gamepad_adapter.enable()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_skirmish(args[0])

func close_skirmish():
	self.ui.hide_skirmish()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_picker()

func open_settings():
	self.ui.hide_menu()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_settings()

func close_settings():
	self.ui.hide_settings()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_menu()

func open_campaign_selection():
	self.ui.hide_menu()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_campaign_selection(true)

func close_campaign_selection():
	self.ui.hide_campaign_selection()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_menu()

func open_campaign_mission_selection(campaign_name=null):
	self.ui.hide_campaign_selection()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_campaign_mission_selection(campaign_name)

func close_campaign_mission_selection():
	self.ui.hide_campaign_mission_selection()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_campaign_selection()

func open_campaign_mission(campaign_name, mission_no):
	self.ui.hide_campaign_mission_selection()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_campaign_mission(campaign_name, mission_no)

func close_campaign_mission():
	self.ui.hide_campaign_mission()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_campaign_mission_selection()

func reopen_campaign_mission_selection_after_win():
	self.match_setup.campaign_win = false
	self.ui.hide_menu()
	self.ui.campaign_selection.show_first_page()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	if self.campaign.is_campaign_complete(self.match_setup.campaign_name):
		self.ui.show_campaign_mission_selection(self.match_setup.campaign_name)
	else:
		self.ui.campaign_mission_selection.load_campaign(self.match_setup.campaign_name)
		if self.match_setup.has_won:
			self.ui.show_campaign_mission(self.match_setup.campaign_name, self.match_setup.mission_no + 1)
		else:
			self.ui.show_campaign_mission(self.match_setup.campaign_name, self.match_setup.mission_no)

func open_controls():
	self.ui.hide_menu()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_controls()

func close_controls():
	self.ui.hide_controls()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_menu()

func open_saves():
	self.ui.hide_menu()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_saves()

	self.ui.saves.bind_cancel(self, "close_saves")

func close_saves():
	self.ui.hide_saves()
	self.gamepad_adapter.enable()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_menu()

func open_online():
	self.ui.hide_menu()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_online()

func close_online():
	self.ui.hide_online()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_menu()


func open_upload_picker():
	self.ui.hide_online()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.picker.set_select_mode()
	self.ui.picker.lock_tab_bar()
	self.ui.show_picker()

	self.ui.picker.bind_cancel(self, "close_upload_picker")
	self.ui.picker.bind_success(self, "handle_upload_output")

func close_upload_picker():
	self.ui.hide_picker()
	self.gamepad_adapter.enable()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.picker.unlock_tab_bar()
	self.ui.show_online()

func handle_upload_output(args):
	self.ui.hide_picker()
	self.gamepad_adapter.enable()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.picker.unlock_tab_bar()
	self.ui.online.selected_upload_map = args[0]
	self.ui.show_online()

func open_download_picker():
	self.ui.hide_online()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.picker.set_browse_mode()
	self.ui.show_picker()

	self.ui.picker.bind_cancel(self, "close_download_picker")
	self.ui.picker.bind_success(self, "handle_download_output")

func close_download_picker():
	self.ui.hide_picker()
	self.gamepad_adapter.enable()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.picker.unlock_tab_bar()
	self.ui.picker.list_mode = self.ui.picker.map_list_service.LIST_STOCK
	self.ui.picker.current_page = 0
	self.ui.online.selected_download_map = null
	self.ui.show_online()

func handle_download_output(args):
	self.ui.hide_picker()
	self.gamepad_adapter.enable()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.picker.unlock_tab_bar()
	self.ui.picker.list_mode = self.ui.picker.map_list_service.LIST_STOCK
	self.ui.picker.current_page = 0
	self.ui.online.selected_download_map = args[0]
	self.ui.show_online()

func open_multiplayer():
	self.ui.hide_menu()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_multiplayer()

func close_multiplayer():
	self.ui.hide_multiplayer()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_menu()

func open_multiplayer_picker():
	self.ui.hide_multiplayer()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.picker.set_select_mode()
	self.ui.picker.lock_tab_bar_downloaded()
	self.ui.show_picker()

	self.ui.picker.bind_cancel(self, "close_multiplayer_picker")
	self.ui.picker.bind_success(self, "handle_multiplayer_picker_output")

func close_multiplayer_picker():
	self.ui.hide_picker()
	self.gamepad_adapter.enable()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.picker.unlock_tab_bar()
	self.ui.show_multiplayer()

func handle_multiplayer_picker_output(args):
	self.ui.hide_picker()
	self.gamepad_adapter.enable()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_multiplayer_lobby(args[0])

func open_multiplayer_lobby():
	self.ui.hide_multiplayer()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_multiplayer_lobby()

func close_multiplayer_lobby():
	self.ui.hide_multiplayer_lobby()
	await self.get_tree().create_timer(self.MENU_TIMEOUT).timeout
	self.ui.show_multiplayer()
