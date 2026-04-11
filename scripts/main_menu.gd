extends Control

@onready var CUTSCENE = load("uid://bxb0tmuhlci5o")
@onready var transition: AnimationPlayer = $Transition
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	player.velocity.y += -70

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(CUTSCENE)

func _on_exit_pressed() -> void:
	get_tree().quit()
