extends CanvasLayer

@onready var MAIN_MENU = load("uid://dx7h1rxfqof3v") as PackedScene
@onready var sound_enabled: TextureButton = $"UI/Sound Enabled"
@onready var music_enabled: TextureButton = $"UI/Music Enabled"
@onready var sound: TextureButton = $UI/Sound
@onready var music: TextureButton = $UI/Music
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var blur: ColorRect = $UI/Blur

var paused := false

func _ready() -> void:
	visible = false
	get_tree().paused = false

func _on_resume_pressed() -> void:
	visible = false
	animation.play_backwards("on")
	get_tree().paused = false
	paused = false

func _on_pause_pressed() -> void:
	visible = true
	get_tree().paused = true
	paused = true
	animation.play("on")

func _on_replay_pressed() -> void:
	Shortcuts.game_over = false
	Shortcuts.coins = 0
	Shortcuts.lifes = 3
	Shortcuts.tutorial_played = false
	get_tree().paused = false
	paused = false
	get_tree().change_scene_to_packed(MAIN_MENU)

func _on_sound_pressed() -> void:
	sound_enabled.visible = true
	sound.visible = false
	var sound_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(sound_bus, 0) 

func _on_music_pressed() -> void:
	music_enabled.visible = true
	music.visible = false
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, 0) 

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_sound_enabled_pressed() -> void:
	sound.visible = true
	sound_enabled.visible = false
	var sound_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(sound_bus, -80) 

func _on_music_enabled_pressed() -> void:
	music.visible = true
	music_enabled.visible = false
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, -80) 
