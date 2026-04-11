class_name Enemy
extends CharacterBody2D

@onready var laser := load("uid://dx1pno2t1v35i")
@onready var shoot_cooldown: Timer = $"Shoot Cooldown"
@onready var collision: CollisionShape2D = $Collision
@onready var ship: Sprite2D = $Ship
@onready var flame: Sprite2D = $Ship/Flame
@onready var root := get_tree().get_root().get_node("World")
@onready var COIN = load("uid://np7vlpikl3cd")
@onready var laser_sound: AudioStreamPlayer2D = $Laser
@onready var explosion: AudioStreamPlayer2D = $Explosion

@export var SPEED = 150.0
@export var COOLDOWN := 0.1

var is_alive := true
var can_shoot := true
var can_move := true
var start_hunting := false
var nearby := false

func _ready() -> void:
	shoot_cooldown.wait_time = COOLDOWN

func _physics_process(delta: float) -> void:
	# Move Toward Player if nearby
	var direction: Vector2
	if nearby and !start_hunting:
		direction = (Shortcuts.player_pos - global_position).normalized()
	else:
		pass
	
	# Rotate towards player
	if direction != Vector2.ZERO:
		rotation = direction.angle()
	
	# Apply Movement
	if direction and can_move:
		velocity = direction * SPEED
	else:
		velocity.x = lerp(velocity.x, Vector2.ZERO.x * SPEED, delta)
		velocity.y = lerp(velocity.y, Vector2.ZERO.y * SPEED, delta)
	move_and_slide()

func die() -> void:
	# Die
	is_alive = false
	can_move = false
	can_shoot = false
	collision.queue_free()
	ship.visible = false
	flame.visible = false
	shoot_cooldown.stop()
	var instance  = COIN.instantiate()
	instance.global_position = global_position
	instance.z_index = z_index - 1
	root.add_child.call_deferred(instance)
	explosion.play()
	await get_tree().create_timer(1).timeout
	self.queue_free()

func shoot() -> void:
	# Shoot
	can_shoot = false
	var instance  = laser.instantiate()
	instance.EXCLUDE = self
	instance.direction = rotation
	instance.spawn_position = global_position
	instance.spawn_rotation = rotation
	instance.z_index = z_index - 1
	root.add_child.call_deferred(instance)
	shoot_cooldown.start()
	can_shoot = false
	laser_sound.play()
	shoot_cooldown.start()

func _on_shoot_cooldown_timeout() -> void:
	# End Cooldown
	can_shoot = true

func _on_leave_body_entered(body: Node2D) -> void:
	# Stop Hunting Player
	if body is Player:
		start_hunting = false
		print(start_hunting)

func _on_start_body_entered(body: Node2D) -> void:
	# Hunt Player
	if body is Player:
		start_hunting = true
