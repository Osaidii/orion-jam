extends Control

@onready var CUTSCENE = load("uid://bxb0tmuhlci5o")
@onready var player: CharacterBody2D = $Player
@onready var CREDITS = load("uid://bd667qr7l5i4w")

func _ready() -> void:
	Transition.scene_in()
	player.velocity.y += -70

func _on_start_pressed() -> void:
	Transition.scene_out()
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_packed(CUTSCENE)
	

func _on_exit_pressed() -> void:
	Transition.scene_out()
	await get_tree().create_timer(1.1).timeout
	get_tree().quit()

func _on_credits_pressed() -> void:
	Transition.scene_out()
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_packed(CREDITS)
