extends Control

@onready var animate: AnimationPlayer = $Transition/Animate
@onready var MAIN_MENU = load("uid://dx7h1rxfqof3v")

func _on_animate_animation_finished(anim_name: StringName) -> void:
	if anim_name == "credits":
		animate.play("out")
		await get_tree().create_timer(1.1).timeout
		get_tree().change_scene_to_packed(MAIN_MENU)
