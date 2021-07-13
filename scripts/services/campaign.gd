extends Node

const PROGRESS_FILE_PATH = "user://campaigns.json"
const CORE_CAMPAIGNS_BASE_PATH = "res://assets/campaigns/"
const CAMPAIGN_MANIFEST = "/campaign.json"

var filesystem = preload("res://scripts/services/filesystem.gd").new()

var campaign_progress = {
    "tutorial" : {
        "progress" : 1,
        "complete" : true,
    }
}

var registered_core_campaign_names = [
    "tutorial",
    "core_prologue",
    "core_sapphire_dawn",
]

var core_campaigns = []
var core_campaigns_by_name = {}
var custom_campaigns = []
var custom_campaigns_by_name = {}

func _ready():
    self._load_campaign_progress()
    self._load_core_campaigns()
    self._load_custom_campaigns()

func get_campaigns():
    return self.core_campaigns + self.custom_campaigns

func get_campaign(campaign_name):
    if self.core_campaigns_by_name.has(campaign_name):
        return self.core_campaigns_by_name[campaign_name]
    elif self.custom_campaigns_by_name.has(campaign_name):
        return self.custom_campaigns_by_name[campaign_name]
    return null

func get_campaign_progress(campaign_name):
    if self.campaign_progress.has(campaign_name):
        return self.campaign_progress[campaign_name]["progress"]
    return 0

func update_campaign_progress(campaign_name, scenario_name):
    if not self.campaign_progress.has(campaign_name):
        self.campaign_progress[campaign_name] = {
            "progress" : 0,
            "complete" : false,
        }

    var progress = self._get_scenario_index(campaign_name, scenario_name)

    if progress > self.campaign_progress[campaign_name]["progress"]:
        self.campaign_progress[campaign_name]["progress"] = progress
        self.campaign_progress[campaign_name]["complete"] = self._is_last_scenario(campaign_name, scenario_name)

    self._save_campaign_progress()

func is_campaign_complete(campaign_name):
    if self.campaign_progress.has(campaign_name):
        return self.campaign_progress[campaign_name]["complete"]
    return false

func _load_campaign_progress():
    var loaded_progress = self.filesystem.read_json_from_file(self.PROGRESS_FILE_PATH)

    for campaign_name in loaded_progress:
        self.campaign_progress[campaign_name] = loaded_progress[campaign_name]

func _save_campaign_progress():
    self.filesystem.write_data_as_json_to_file(self.PROGRESS_FILE_PATH, self.campaign_progress)

func _load_core_campaigns():
    var campaign_details = null

    for registered_campaign in self.registered_core_campaign_names:
        campaign_details = self._load_campaign_details(self.CORE_CAMPAIGNS_BASE_PATH + registered_campaign)
        if campaign_details != null:
            self.core_campaigns.append(campaign_details)
            self.core_campaigns_by_name[registered_campaign] = campaign_details
    

func _load_custom_campaigns():
    return

func _load_campaign_details(directory_path):
    var manifest_path = directory_path + self.CAMPAIGN_MANIFEST
    var details = null

    if self.filesystem.file_exists(manifest_path):
        details = self.filesystem.read_json_from_file(manifest_path)
        if self._validate_manifest(details, directory_path):
            return details

    return null

func _validate_manifest(manifest, directory_path):
    if not manifest.has("missions"):
        return false

    for mission in manifest["missions"]:
        if not self.filesystem.file_exists(directory_path + "/maps/" + mission["map"]):
            return false

    return true

func _get_scenario_index(campaign_name, scenario_name):
    var manifest = self.get_campaign(campaign_name)
    if manifest == null:
        return 0

    return self._search_manifest_for_scenario_index(manifest, scenario_name)

func _search_manifest_for_scenario_index(manifest, scenario_name):
    var index = 0

    for mission_details in manifest["missions"]:
        index += 1
        if mission_details["name"] == scenario_name:
            return index 

    return 0

func _is_last_scenario(campaign_name, scenario_name):
    var index = self._get_scenario_index(campaign_name, scenario_name)

    var manifest = self.get_campaign(campaign_name)
    if manifest == null:
        return false

    return index == manifest["missions"].size()