extends Node
class_name AudioLibrary

const BUS_SFX: String = "SFX"
const BUS_MUSIC: String = "Music"

var samples: Dictionary = {}
var soundtracks: Dictionary = {}
var current_track: AudioStreamPlayer = null
var _last_requested_track: AudioStreamPlayer = null

var master_switch: bool = false
var sounds_enabled: bool = true
var music_enabled: bool = true

func _ready() -> void:
	self.register_sample("click", preload("res://assets/audio/menu.wav"))
	self.register_sample("menu_click", preload("res://assets/audio/menu_click.wav"))
	self.register_sample("menu_back", preload("res://assets/audio/menu_back.wav"))
	self.register_sample("explosion", preload("res://assets/audio/explosion.wav"))
	self.register_sample("map_click", preload("res://assets/audio/map_click.wav"))
	self.register_sample("fanfare", preload("res://assets/audio/fanfare.wav"))
	self.register_sample("failfare", preload("res://assets/audio/failfare.wav"))


	self.register_track("intro", preload("res://assets/audio/soundtrack/grand_beats_intro.ogg"))
	self.register_track("menu", preload("res://assets/audio/soundtrack/grand_beats_menu_soundtrack.ogg"))
	self.register_track("soundtrack_1", preload("res://assets/audio/soundtrack/grand_beats_soundtrack_1_metal.ogg"))
	self.register_track("soundtrack_2", preload("res://assets/audio/soundtrack/grand_beats_110.ogg"))
	self.register_track("soundtrack_3", preload("res://assets/audio/soundtrack/reduz_all_star_champion_sheep.ogg"))
	self.register_track("soundtrack_4", preload("res://assets/audio/soundtrack/reduz_like_a_whale.ogg"))
	self.register_track("soundtrack_5", preload("res://assets/audio/soundtrack/reduz_the_sorrows_of_a_crab.ogg"))
	self.register_track("soundtrack_6", preload("res://assets/audio/soundtrack/reduz_capybara_love.ogg"))


func play(sample_name: String) -> void:
	if not self.master_switch or not self.sounds_enabled:
		return

	if not self.samples.has(sample_name):
		return

	self.samples[sample_name].play()

func track(track_name: String) -> void:
	if not self.soundtracks.has(track_name):
		return

	self._last_requested_track = self.soundtracks[track_name]

	if not self.master_switch or not self.music_enabled:
		return

	self.stop()
	self.soundtracks[track_name].play()
	self.current_track = self.soundtracks[track_name]

func is_playing(track_name: String) -> bool:
	if not self.music_enabled:
		return false

	if not self.soundtracks.has(track_name):
		return false

	return self.soundtracks[track_name].is_playing()

func stop(track_name: String = "") -> void:
	for registered_track: AudioStreamPlayer in self.soundtracks.values():
		registered_track.stop()

	if track_name == "" and self.current_track != null:
		self.current_track.stop()
		self.current_track = null
	elif self.soundtracks.has(track_name):
		self.soundtracks[track_name].stop()

func pause(track_name: String = "") -> void:
	if track_name == "" and self.current_track != null:
		self.current_track.set_stream_paused(true)
	elif self.soundtracks.has(track_name):
		self.soundtracks[track_name].set_stream_paused(true)

func unpause(track_name: String = "") -> void:
	if track_name == "" and self.current_track != null:
		self.current_track.set_stream_paused(false)
	elif self.soundtracks.has(track_name):
		self.soundtracks[track_name].set_stream_paused(false)


func register_sample(sample_name: String, stream: AudioStream) -> void:
	if stream == null:
		return

	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	self.get_tree().get_root().call_deferred("add_child", sfx)
	sfx.set_stream(stream)
	sfx.set_bus(self.BUS_SFX)

	self.samples[sample_name] = sfx


func register_track(track_name: String, stream: AudioStream) -> void:
	if stream == null:
		return

	var new_track: AudioStreamPlayer = AudioStreamPlayer.new()
	self.get_tree().get_root().call_deferred("add_child", new_track)
	new_track.set_stream(stream)
	new_track.set_bus(self.BUS_MUSIC)

	self.soundtracks[track_name] = new_track

func restart_track() -> void:
	if not self.master_switch or not self.music_enabled:
		return

	if self._last_requested_track != null and not self._last_requested_track.is_playing():
		self.current_track = self._last_requested_track
		self._last_requested_track.play()
