extends CharacterBody2D

@export var SPEED = 300
@export var EXCLUDE: CharacterBody2D

@onready var explosion := load("uid://tntu14kag51h")
@onready var root := get_tree().get_root().get_node("World")

var direction: float
var spawn_position: Vector2
var spawn_rotation: float

func _ready() -> void:
	global_position = spawn_position
	global_rotation = spawn_rotation + deg_to_rad(90)

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0, -SPEED).rotated(direction + deg_to_rad(90))
	move_and_slide()

func _on_check_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body != EXCLUDE and body.is_alive:
		body.die()
		var instance  = explosion.instantiate()
		instance.global_position = global_position
		instance.rotation = rotation
		instance.z_index = z_index + 1
		root.add_child.call_deferred(instance)
		instance.play("explode")
		self.queue_free()
