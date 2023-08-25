extends "res://scenes/ui/menu/base_menu_panel.gd"

onready var campaign = $"/root/Campaign"
onready var switcher = $"/root/SceneSwitcher"
onready var match_setup = $"/root/MatchSetup"

onready var back_button = $"widgets/back_button"
onready var start_button = $"widgets/start_button"
onready var title = $"widgets/title"
onready var description = $"widgets/description"

var manifest
var mission_no = 0

func _on_back_button_pressed():
    ._on_back_button_pressed()
    self.main_menu.close_campaign_mission()

func _on_start_button_pressed():
    self.audio.play("menu_click")

    var mission_details = self.manifest["missions"][self.mission_no]

    self.match_setup.reset()
    self.match_setup.campaign_name = self.manifest["name"]
    self.match_setup.mission_no = self.mission_no

    for player in mission_details["players"]:
        if not player.has("alive"):
            player["alive"] = true
        if not player.has("team"):
            player["team"] = null
        self.match_setup.add_player(player["side"], player["ap"], player["type"], player["alive"], player["team"])

    self.switcher.board()

func show_panel():
    .show_panel()
    yield(self.get_tree().create_timer(0.1), "timeout")
    self.start_button.grab_focus()

func load_mission(campaign_name, _mission_no):
    self.manifest = self.campaign.get_campaign(campaign_name)
    self.mission_no = _mission_no

    if self.manifest == null:
        self.main_menu.close_campaign_mission()
        return

    var mission_details = self.manifest["missions"][self.mission_no]

    self.title.set_text(mission_details["title"])
    self.description.set_text(mission_details["description"])
