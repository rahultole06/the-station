# Made by: Rahul M. Tole
# Class: Player mechanic logic
extends CharacterBody2D

# Instance variables
const SPEED = 200.0 # player speed
const LADDER_SPEED = 50
const JUMP_VELOCITY = -250.0 
const SLOW_DOWN_STEP = 10 # Smoothen player stopping motion
var isLeft = false # stores direction player is facing
var gun = false # checks if player has gun
var canShoot = true # used for shoot interval
var health = 5 # player health
var isDodging = false # to check if player is dodging
var onLadder = false; # checks if player is on ladder
@export var health_bar : Array[Node]

# Reference to other objects
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var game_manager: Node = %GameManager
const bullet = preload("res://scenes/bullet.tscn")
@onready var game_over_panel: Panel = %GameOverPanel
@onready var shoot_interval: Timer = %ShootInterval
@onready var health_panel: Panel = $"../../UI/HealthPanel"
@onready var normal_hit_box: CollisionShape2D = $NormalHitBox
@onready var dodge_hit_box: CollisionShape2D = $DodgeHitBox

# makes sure dodge hitbox is disabled on start
func _ready() -> void:
	dodge_hit_box.set_deferred("disabled", true)

# Setter/Getter for gun 
func getGun():
	gun = true
	
func hasGun():
	return gun

# decrease health by x
func decrease_health(x):
	health -= x
	health_bar[health].hide()
	if (health == 0):
		get_tree().paused = true
		health_panel.hide()
		game_over_panel.show()

# Handles player action logic
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() && !onLadder:
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
	#if Input.is_action_just_pressed("jump") and is_on_floor() && !isDodging:
		#velocity.y = JUMP_VELOCITY

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
	if Input.is_action_just_pressed("shoot") && hasGun() && !isDodging && canShoot:	
		var b = bullet.instantiate() # make instance of a new bullet
		
		# Sets direction of bullet based on player
		if sign($Marker2D.position.x) == 1:
			b.set_direction(1)
		else:
			b.set_direction(-1)
		
		get_parent().add_child(b) # add to scene
		b.show() # display bullet
		b.position = $Marker2D.global_position # set bullet start at gun
		shoot_interval.start() # shoot interval handling
		canShoot = false # disables rapid shots
	
	# dodging input
	if hasGun() && !onLadder:
		if Input.is_action_just_pressed("dodge") && hasGun():
			canShoot = false
			isDodging = true
			
			# hitbox handling
			normal_hit_box.set_deferred("disabled", true)
			dodge_hit_box.set_deferred("disabled", false)
		if Input.is_action_just_released("dodge") && hasGun():
			canShoot = true
			isDodging = false
			
			# hitbox handling
			normal_hit_box.set_deferred("disabled", false)
			dodge_hit_box.set_deferred("disabled", true)
	
	# handles ladder climb input
	if onLadder && !isDodging:
		if Input.is_action_pressed("up"): # going up
			velocity.y = -LADDER_SPEED
		elif Input.is_action_pressed("down"): # going down
			velocity.y = LADDER_SPEED
		else: # stop on ladder
			velocity.y = 0

# Update animation sprite based on action
func updateAnimation():
	# Flip the sprite horizontally based on the direction
	animated_sprite_2d.flip_h = isLeft
	if isDodging: # player is dodging
		animated_sprite_2d.animation = "dodge"
	elif abs(velocity.x) > 1: # idle player sprite
		if (hasGun()): # if player has gun
			animated_sprite_2d.animation = "walking_gun"
		else:
			animated_sprite_2d.animation = "walking"
	else: # walking sprite
		if (hasGun()): # if player has gun
			animated_sprite_2d.animation = "idle_gun"
		else:
			animated_sprite_2d.animation = "idle"
	animated_sprite_2d.play()
