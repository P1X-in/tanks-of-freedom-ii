
var map

func _init(map_scene):
    self.map = map_scene

func save_map_file(filename):
    if self.map.model.metadata.has("iteration"):
        self.map.model.metadata["iteration"] += 1
    if not self.map.model.metadata.has("name") or self.map.model.metadata["name"] != filename:
        self.map.model.metadata["name"] = filename
        self.map.model.metadata["iteration"] = 0
        self.map.model.metadata["base_code"] = null
    var map_data = self.map.model.get_dict()
    MapManager.save_map_to_file(filename, map_data)

func load_map_file(filename):
    var content = MapManager.get_map_data(filename)
    if content.empty():
        return

    self.map.builder.wipe_map()
    self.map.builder.fill_map_from_data(content)
    self._initialize_camera_position()

func load_campaign_map(campaign_name, mission_no):
    var content = self.map.campaign.get_campaign_mission_map(campaign_name, mission_no)
    self.map.builder.wipe_map()
    self.map.builder.fill_map_from_data(content)
    self._initialize_camera_position()

func _initialize_camera_position():
    if self.map.model.metadata.has("initial_cam_pos"):
        var position = Vector2(self.map.model.metadata["initial_cam_pos"][0], self.map.model.metadata["initial_cam_pos"][1])
        self.map.snap_camera_to_position(position)
