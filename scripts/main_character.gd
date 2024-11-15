# Made by: Rahul M. Tole
# Class: Player mechanic logic
extends CharacterBody2D

# Instance variables
const SPEED = 200.0 # player speed
const JUMP_VELOCITY = -250.0 
const SLOW_DOWN_STEP = 10 # Smoothen player stopping motion
var isLeft = false # stores direction player is facing
var health = 10 # player health

# Reference to other objects
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var game_manager: Node = %GameManager
const bullet = preload("res://scenes/bullet.tscn")
@onready var game_over_panel: Panel = %GameOverPanel

# decrease health by x
func decrease_health(x):
	health -= x
	if (health == 0):
		get_tree().paused = true
		game_over_panel.show()

# Handles player action logic
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("shoot") && game_manager.hasGun():
		var b = bullet.instantiate()
		if sign($Marker2D.position.x) == 1:
			b.set_direction(1)
		else:
			b.set_direction(-1)
		get_parent().add_child(b)
		b.show()
		b.position = $Marker2D.global_position

	move_and_slide()

	# Check if the player is moving left or right
	if velocity.x < 0:
		isLeft = true
		if sign($Marker2D.position.x) == 1:
			$Marker2D.position.x *= -1
	elif velocity.x > 0:
		isLeft = false
		if sign($Marker2D.position.x) == -1:
			$Marker2D.position.x *= -1
		

	# Flip the sprite horizontally based on the direction
	animated_sprite_2d.flip_h = isLeft
	
	# Change sprite based on action
	if abs(velocity.x) > 1: # idle player sprite
		if (game_manager.hasGun()): # if player has gun
			animated_sprite_2d.animation = "walking_gun"
		else:
			animated_sprite_2d.animation = "walking"
	else: # walking sprite
		if (game_manager.hasGun()): # if player has gun
			animated_sprite_2d.animation = "idle_gun"
		else:
			animated_sprite_2d.animation = "idle"
