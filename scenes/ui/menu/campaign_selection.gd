extends Control

const TILES_PER_PAGE = 6

onready var audio = $"/root/SimpleAudioLibrary"
onready var campaign = $"/root/Campaign"

onready var animations = $"animations"
onready var prev_button = $"widgets/prev_button"
onready var next_button = $"widgets/next_button"

onready var campaign_tiles = [
    $"widgets/campaign1",
    $"widgets/campaign2",
    $"widgets/campaign3",
    $"widgets/campaign4",
    $"widgets/campaign5",
    $"widgets/campaign6",
]

var icons = preload("res://scenes/ui/icons/icons.gd").new()

var main_menu
var page = 0

var last_campaign_tile_clicked = null

func bind_menu(menu):
    self.main_menu = menu

    for campaign_tile in self.campaign_tiles:
        campaign_tile.bind_menu(menu)

func _ready():
    self.set_process_input(false)

func _input(event):
    if event.is_action_pressed("ui_cancel") or event.is_action_pressed('editor_menu'):
        self._on_back_button_pressed()

func _on_back_button_pressed():
    self.audio.play("menu_back")
    self.main_menu.close_campaign_selection()

func _on_prev_button_pressed():
    self.audio.play("menu_click")
    self._switch_to_page(self.page - 1)
    if self._is_first_page():
        self.campaign_tiles[0].focus_tile()

func _on_next_button_pressed():
    self.audio.play("menu_click")
    self._switch_to_page(self.page + 1)
    if self._is_last_page():
        self.campaign_tiles[0].focus_tile()

func show_panel():
    self.animations.play("show")
    self.set_process_input(true)
    yield(self.get_tree().create_timer(0.1), "timeout")
    self.restore_focus()

func hide_panel():
    self.animations.play("hide")
    self.set_process_input(false)

func show_first_page():
    self._switch_to_page(0)

func _is_first_page():
    return self.page == 0

func _is_last_page():
    return self.page == self._get_amount_of_pages() - 1

func _get_amount_of_pages():
    var campaigns = self.campaign.get_campaigns()

    var amount = campaigns.size()
    var overflow = amount % self.TILES_PER_PAGE
    var pages = (amount - overflow) / self.TILES_PER_PAGE

    if overflow > 0:
        pages += 1

    return pages

func _switch_to_page(page_no):
    self.page = page_no

    var campaigns = self.campaign.get_campaigns()

    var index = 0
    var campaign_index = 0

    while index < self.TILES_PER_PAGE:
        campaign_index = page_no * self.TILES_PER_PAGE + index

        if campaign_index < campaigns.size():
            self._fill_tile(self.campaign_tiles[index], campaigns[campaign_index])
        else:
            self.campaign_tiles[index].hide()
        index += 1
    self._manage_navigation()

func _fill_tile(tile, manifest):
    tile.show()

    var icon = self.icons.get_named_icon(manifest["icon"])

    if manifest.has("prerequisite"):
        if not self.campaign.is_campaign_complete(manifest["prerequisite"]):
            tile.set_locked(icon)
            return

    tile.set_up(manifest["title"], icon, manifest["name"])
    if self.campaign.is_campaign_complete(manifest["name"]):
        tile.set_complete()

func _manage_navigation():
    if self._is_first_page():
        self.prev_button.hide()
    else:
        self.prev_button.show()

    if self._is_last_page():
        self.next_button.hide()
    else:
        self.next_button.show()

func restore_focus():
    if self.last_campaign_tile_clicked != null:
        self.last_campaign_tile_clicked.focus_tile()
        self.last_campaign_tile_clicked = null
    else:
        self.campaign_tiles[0].focus_tile()
