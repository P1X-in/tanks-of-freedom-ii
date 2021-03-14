extends Control

const PLAYER_HUMAN = "human"
const PLAYER_AI = "ai"
const PLAYER_HUMAN_LABEL = "Human"
const PLAYER_AI_LABEL = "AI"

const AP_STEP = 50
const AP_MAX = 150

onready var blue_player = $"blue_player"
onready var red_player = $"red_player"
onready var yellow_player = $"yellow_player"
onready var green_player = $"green_player"

onready var type_button = $"player_type"
onready var ap_button = $"starting_ap"

var side
var ap
var type

onready var audio = $"/root/SimpleAudioLibrary"

func fill_panel(player_side):
    self._reset_labels()

    self.side = player_side

    match player_side:
        "blue":
            self.blue_player.show()
        "red":
            self.red_player.show()
        "yellow":
            self.yellow_player.show()
        "green":
            self.green_player.show()

func _reset_labels():
    self.blue_player.hide()
    self.red_player.hide()
    self.yellow_player.hide()
    self.green_player.hide()

    self.ap = self.AP_STEP
    self.type = self.PLAYER_HUMAN
    self.side = null

    self._update_type_label()
    self._update_ap_label()

func _update_type_label():
    if self.type == self.PLAYER_HUMAN:
        self.type_button.set_text(self.PLAYER_HUMAN_LABEL)
    else:
        self.type_button.set_text(self.PLAYER_AI_LABEL)

func _update_ap_label():
    self.ap_button.set_text(str(self.ap) + " AP")


func _on_player_type_pressed():
    self.audio.play("menu_click")
    if self.type == self.PLAYER_HUMAN:
        self.type = self.PLAYER_AI
    else:
        self.type = self.PLAYER_HUMAN
    self._update_type_label()


func _on_starting_ap_pressed():
    self.audio.play("menu_click")
    self.ap += self.AP_STEP
    if self.ap > self.AP_MAX:
        self.ap = 0
    self._update_ap_label()
