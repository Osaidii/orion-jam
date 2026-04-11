extends Node2D

@onready var WORLD = load("uid://jlyujdd31grn") as PackedScene

func _on_cutscenes_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scene":
		get_tree().change_scene_to_packed(WORLD)
