# Made by: Rahul M. Tole
# Class: Player mechanic logic
extends CharacterBody2D

# Instance variables
const SPEED = 200.0 # player speed
const JUMP_VELOCITY = -250.0 
const SLOW_DOWN_STEP = 10 # Smoothen player stopping motion
var isLeft = false # stores direction player is facing
var canShoot = true # used for shoot interval
var health = 5 # player health
var isDodging = false # to check if player is dodging

# Reference to other objects
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var game_manager: Node = %GameManager
const bullet = preload("res://scenes/bullet.tscn")
@onready var game_over_panel: Panel = %GameOverPanel
@onready var shoot_interval: Timer = %ShootInterval
@onready var health_panel: Panel = $"../../UI/HealthPanel"
@onready var normal_hit_box: CollisionShape2D = $NormalHitBox
@onready var dodge_hit_box: CollisionShape2D = $DodgeHitBox


# decrease health by x
func decrease_health(x):
	health -= x
	game_manager.health_bar[health].hide()
	if (health == 0):
		get_tree().paused = true
		health_panel.hide()
		game_over_panel.show()

# Handles player action logic
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	inputMap() # input logic
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

	updateAnimation() # animate the sprite
	

# Reset canShoot to allow player to shoot again
func _on_shoot_interval_timeout() -> void:
	canShoot = true	

func inputMap():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && !isDodging:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if !isDodging:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = 0
	
	# Shoot logic
	if Input.is_action_just_pressed("shoot") && game_manager.hasGun() && !isDodging && canShoot:	
		var b = bullet.instantiate()
		if sign($Marker2D.position.x) == 1:
			b.set_direction(1)
		else:
			b.set_direction(-1)
		get_parent().add_child(b)
		b.show()
		b.position = $Marker2D.global_position
		shoot_interval.start() # interval handling
		canShoot = false
	
	if Input.is_action_just_pressed("dodge") && game_manager.hasGun():
		canShoot = false
		isDodging = true
		normal_hit_box.set_deferred("disabled", true)
	
	if Input.is_action_just_released("dodge") && game_manager.hasGun():
		canShoot = true
		isDodging = false
		normal_hit_box.set_deferred("disabled", false)

# Update animation sprite based on action
func updateAnimation():
	# Flip the sprite horizontally based on the direction
	animated_sprite_2d.flip_h = isLeft
	if isDodging: # player is dodging
		animated_sprite_2d.animation = "dodge"
	elif abs(velocity.x) > 1: # idle player sprite
		if (game_manager.hasGun()): # if player has gun
			animated_sprite_2d.animation = "walking_gun"
		else:
			animated_sprite_2d.animation = "walking"
	else: # walking sprite
		if (game_manager.hasGun()): # if player has gun
			animated_sprite_2d.animation = "idle_gun"
		else:
			animated_sprite_2d.animation = "idle"
	animated_sprite_2d.play()
