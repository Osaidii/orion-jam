extends Node2D

@onready var WORLD = load("uid://jlyujdd31grn") as PackedScene
@onready var cutscenes: AnimationPlayer = $Cutscenes
@onready var win_screen: MarginContainer = $"Screens/Win Screen"
@onready var MAIN_MENU = load("uid://dx7h1rxfqof3v")

func _ready() -> void:
	Transition.scene_in()
	if Shortcuts.game_over:
		cutscenes.stop()
		cutscenes.play("ending")

func _on_cutscenes_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scene":
		Transition.scene_out()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(WORLD)
	if anim_name == "ending":
		win_screen.visible = true

func _on_exit_pressed() -> void:
	Shortcuts.game_over = false
	Shortcuts.coins = 0
	Shortcuts.lifes = 3
	Shortcuts.tutorial_played = false
	Transition.scene_out()
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_packed(MAIN_MENU)

func _on_replay_pressed() -> void:
	Shortcuts.game_over = false
	Shortcuts.coins = 0
	Shortcuts.lifes = 3
	Shortcuts.tutorial_played = false
	Transition.scene_out()
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_packed(WORLD)
