extends CanvasLayer

@onready var animate: AnimationPlayer = $Animate

func scene_in() -> void:
	animate.play("in")

func scene_out() -> void:
	animate.play("out")
