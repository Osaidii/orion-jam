class_name Player
extends CharacterBody2D

@onready var flame: Sprite2D = $Ship/Flame
@onready var ship: Sprite2D = $Ship
@onready var laser := load("uid://dx1pno2t1v35i")
@onready var explosion := load("uid://tntu14kag51h")
@onready var shoot_cooldown: Timer = $"Shoot Cooldown"
@onready var collision: CollisionShape2D = $Collision
@onready var root := get_tree().current_scene
@onready var tutorial: Label = $"../UI/Tutorial"
@onready var coin: AudioStreamPlayer2D = $Coin
@onready var laser_sound: AudioStreamPlayer2D = $Laser
@onready var explosion_sound: AudioStreamPlayer2D = $Explosion
@onready var heart_1: AnimatedSprite2D = $"../UI/Hearts/Heart 1"
@onready var heart_2: AnimatedSprite2D = $"../UI/Hearts/Heart 2"
@onready var heart_3: AnimatedSprite2D = $"../UI/Hearts/Heart 3"

@export var speed := 150
@export var COOLDOWN := 0.1
@export_category("External")
@export var direction: Vector2

var stored_coins := 0
var is_alive := true
var can_shoot := true
var can_move := true
var player_shot_or_moved := false

func _ready() -> void:
	# Set Cooldown
	shoot_cooldown.wait_time = COOLDOWN
	stored_coins = Shortcuts.coins
	match Shortcuts.lifes:
		1:
			heart_2.play("empty")
			heart_3.play("empty")
		2:
			heart_3.play("empty")
		3:
			pass

func _input(event: InputEvent) -> void:
	# Rotate toward Mouse
	if event is InputEventMouseMotion:
		rotation = deg_to_rad(event.relative.y + event.relative.y)

func _physics_process(delta: float) -> void:
	# Get Mouse Position
	var mouse_position = get_global_mouse_position()
		
	# Look at Mouse
	look_at(mouse_position)
	#look_at(lerp(Vector2(rotation, 0), mouse_position, 1.0))
	
	# Shoot
	if Input.is_action_pressed("RMB") and can_shoot:
		player_shot_or_moved = true
		shoot()
	
	# Store Positon Globaly
	Shortcuts.player_pos = global_position
	
	# Coins
	if Shortcuts.coins_to_be_added > 0:
		stored_coins += Shortcuts.coins_to_be_added
		Shortcuts.coins_to_be_added = 0
		coin.play()
	
	# Update Stored Values
	Shortcuts.coins = stored_coins
	Shortcuts.no_tutorial = player_shot_or_moved
	
	# Movement
	var direction := Vector2.ZERO
	if Input.is_action_pressed("LMB") and can_move:
		player_shot_or_moved = true
		direction = (mouse_position - position).normalized()
		var target_velocity = direction * speed
		velocity = lerp(velocity, target_velocity, delta * 2.0)
		flame.visible = true
	else:
		velocity.x = lerp(velocity.x, Vector2.ZERO.x * speed, delta)
		velocity.y = lerp(velocity.y, Vector2.ZERO.y * speed, delta)
		flame.visible = false
	move_and_slide()

func shoot() -> void:
	# Instantiate and Push
	can_shoot = false
	var instance  = laser.instantiate()
	instance.EXCLUDE = self
	instance.direction = rotation
	instance.spawn_position = global_position
	instance.spawn_rotation = rotation
	root.add_child.call_deferred(instance)
	instance.z_index = z_index - 1
	laser_sound.play()
	shoot_cooldown.start()

func _on_shoot_cooldown_timeout() -> void:
	# Shoot Cooldown Over
	can_shoot = true

func die() -> void:
	# Die
	is_alive = false
	can_move = false
	collision.disabled = true
	ship.visible = false
	flame.visible = false
	can_shoot = false
	shoot_cooldown.stop()
	await get_tree().create_timer(4).timeout
	match Shortcuts.lifes:
		1:
			heart_1.play("empty")
		2:
			heart_2.play("empty")
		3:
			heart_3.play("empty")
	Shortcuts.lifes -= 1
	if Shortcuts.lifes > 0:
		get_tree().reload_current_scene()
	else:
		pass # MAKE LOSE SCREEN HERE
	self.queue_free()

func _on_nearby_body_entered(body: Node2D) -> void:
	# Tell Enemy is Nearby
	if body is Enemy:
		body.nearby = true
		print(body.nearby)
