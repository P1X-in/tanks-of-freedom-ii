extends Node2D

onready var animations = $"animations"

onready var blue_player = $"background/blue_player"
onready var red_player = $"background/red_player"
onready var yellow_player = $"background/yellow_player"
onready var green_player = $"background/green_player"

onready var turn_label = $"background/turn"

func flash(player, turn):
    self._reset_labels()
    self.turn_label.set_text("Turn " + str(turn))

    match player:
        "blue":
            self.blue_player.show()
        "red":
            self.red_player.show()
        "yellow":
            self.yellow_player.show()
        "green":
            self.green_player.show()

    self.animations.play("show")

func _reset_labels():
    self.blue_player.hide()
    self.red_player.hide()
    self.yellow_player.hide()
    self.green_player.hide()
