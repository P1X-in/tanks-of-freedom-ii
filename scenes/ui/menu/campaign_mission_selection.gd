extends Control

onready var audio = $"/root/SimpleAudioLibrary"
onready var campaign = $"/root/Campaign"

onready var animations = $"animations"
onready var back_button = $"widgets/back_button"
onready var select_button = $"widgets/select_button"
onready var prev_button = $"widgets/prev_button"
onready var next_button = $"widgets/next_button"

onready var title = $"widgets/title"
onready var mission_anchor = $"widgets/missions_anchor"

var main_menu

var manifest

var mission_marker_template = preload("res://scenes/ui/menu/mission_marker.tscn")
var mission_markers = []
var selected_mission = 0

func bind_menu(menu):
    self.main_menu = menu

func _ready():
    self.set_process_input(false)

func _input(event):
    if event.is_action_pressed("ui_cancel") or event.is_action_pressed('editor_menu'):
        self._on_back_button_pressed()

func _on_back_button_pressed():
    self.audio.play("menu_click")
    self.main_menu.close_campaign_mission_selection()

func _on_prev_button_pressed():
    self.audio.play("menu_click")
    self._select_marker(self.selected_mission - 1)
    if self._is_first_mission():
        self.next_button.grab_focus()

func _on_next_button_pressed():
    self.audio.play("menu_click")
    self._select_marker(self.selected_mission + 1)
    if self._is_last_mission():
        self.prev_button.grab_focus()

func _on_select_button_pressed():
    self.audio.play("menu_click")
    self.main_menu.open_campaign_mission(self.manifest["name"], self.selected_mission)

func show_panel():
    self.animations.play("show")
    self.set_process_input(true)
    yield(self.get_tree().create_timer(0.1), "timeout")
    self.select_button.grab_focus()

func hide_panel():
    self.animations.play("hide")
    self.set_process_input(false)

func load_campaign(campaign_name):
    self.clear_markers()
    self.manifest = self.campaign.get_campaign(campaign_name)

    if self.manifest == null:
        self.main_menu.close_campaign_mission_selection()
        return

    self.title.set_text(manifest["title"])
    self._add_mission_markers(manifest["missions"])
    self._select_latest_mission()

func _add_mission_markers(missions):
    var index = 1
    var marker
    var campaign_progress = self.campaign.get_campaign_progress(self.manifest["name"])

    for mission in missions:
        marker = self._add_mission_marker(index, mission)
        if index <= campaign_progress:
            marker.set_complete()
        index += 1

func _add_mission_marker(index, mission_details):
    var mission_marker = self.mission_marker_template.instance()
    self.mission_markers.append(mission_marker)

    mission_marker.set_mission_title(index, mission_details["title"])
    mission_marker.set_position(Vector2(mission_details["marker"][0], mission_details["marker"][1]))
    self.mission_anchor.add_child(mission_marker)

    return mission_marker

func clear_markers():
    for marker in self.mission_markers:
        marker.queue_free()
    self.mission_markers = []
    self.selected_mission = 0

func _select_latest_mission():
    if self.campaign.is_campaign_complete(self.manifest["name"]):
        self._select_marker(0)
        return

    var campaign_progress = self.campaign.get_campaign_progress(self.manifest["name"])

    if campaign_progress > self.mission_markers.size():
        campaign_progress = self.mission_markers.size() - 1

    self._select_marker(campaign_progress)


func _select_marker(marker_no):
    if self.selected_mission != marker_no:
        self.mission_markers[self.selected_mission].hide_panel()

    self.selected_mission = marker_no
    self.mission_markers[self.selected_mission].show_panel()
    self.mission_markers[self.selected_mission].raise()
    self._manage_navigation()

func _manage_navigation():
    if self._is_first_mission():
        self.prev_button.hide()
    else:
        self.prev_button.show()

    if self._is_last_mission():
        self.next_button.hide()
    else:
        self.next_button.show()

func _is_first_mission():
    return self.selected_mission == 0

func _is_last_mission():
    var campaign_progress = self.campaign.get_campaign_progress(self.manifest["name"])
    return self.selected_mission == campaign_progress or self.selected_mission == self.mission_markers.size() - 1

