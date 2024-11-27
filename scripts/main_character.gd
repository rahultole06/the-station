# Made by: Rahul M. Tole
# Class: Player mechanic logic
extends CharacterBody2D

# constants
const SPEED = 200.0 # player speed
const LADDER_SPEED = 50
const bullet = preload("res://scenes/bullet.tscn")

# instance variables
var isLeft = false # stores direction player is facing
var gun = "none" # checks if player has gun
var hasSuit = false # checks if player has suit
var canShoot = true # used for shoot interval
var health = 5 # player health
var shield = 5 # suit shield
var isDodging = false # to check if player is dodging
var onLadder = false; # checks if player is on ladder
var isSuitUpObjective = false # checks if suit up objective has been hit
var isOnLevelTwo = false # checks if play is on second level
var isOnUnderLevel = false
@export var health_bar : Array[Node]
@export var shield_bar : Array[Node]
@export var objectives : Array[Node]

# Reference to other objects
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var normal_hit_box: CollisionShape2D = $NormalHitBox
@onready var dodge_hit_box: CollisionShape2D = $DodgeHitBox
@onready var game_over_panel: Panel = %GameOverPanel
@onready var shield_panel: Panel = %ShieldPanel
@onready var shoot_interval: Timer = %ShootInterval
@onready var audio_handler: Node = %AudioHandler
@onready var shoot_noise: Node = audio_handler.get_child(0).get_child(1)
@onready var biggun_noise: Node = audio_handler.get_child(0).get_child(4)

# makes sure dodge hitbox is disabled on start
func _ready() -> void:
	dodge_hit_box.set_deferred("disabled", true)

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

	if !isSuitUpObjective && hasBigGun() && hasSuit:
		isSuitUpObjective = true
		objectives[2].hide()
		objectives[3].show()

	if onLadder:
		disableDodge() # stops dodge if on ladder

	updateAnimation() # animate the sprite

# Reset canShoot to allow player to shoot again
func _on_shoot_interval_timeout() -> void:
	canShoot = true	

func inputMap():
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if !isDodging:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else: # stop player movement while dodging
		velocity.x = 0
	
	
	# Shoot logic
	var isEquiped = hasSmallGun() || hasBigGun() # checks if player has any gun
	if Input.is_action_just_pressed("shoot") && isEquiped && !isDodging && canShoot && !onLadder:	
		if hasBigGun(): # shoot audio
			biggun_noise.play()
		else:
			shoot_noise.play() 
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
	if isEquiped && !onLadder:
		if Input.is_action_just_pressed("dodge"):
			enableDodge()
		if Input.is_action_just_released("dodge"):
			disableDodge()
	
	# handles ladder climb input
	if onLadder && !isDodging:
		if Input.is_action_pressed("up"): # going up
			velocity.y = -LADDER_SPEED
		elif Input.is_action_pressed("down"): # going down
			velocity.y = LADDER_SPEED
		else: # stop on ladder
			velocity.y = move_toward(velocity.y, 0, SPEED)
	
# Update animation sprite based on action
func updateAnimation():
	# Flip the sprite horizontally based on the direction
	animated_sprite_2d.flip_h = isLeft
	if isDodging: # player is dodging
		if (hasSuit):
			animated_sprite_2d.animation = "astro_dodge"
		else:
			animated_sprite_2d.animation = "dodge"
	elif abs(velocity.x) > 1: # walking player sprite
		if (hasSuit && hasBigGun()):
			animated_sprite_2d.animation = "astro_walking_gun"
		elif (hasSuit):
			animated_sprite_2d.animation = "astro_walking"
		elif (hasBigGun()):
			animated_sprite_2d.animation = "walking_biggun"
		elif (hasSmallGun()):
			animated_sprite_2d.animation = "walking_gun"
		else:
			animated_sprite_2d.animation = "walking"
	else: # idle sprite
		if (hasSuit && hasBigGun()):
			animated_sprite_2d.animation = "astro_idle_gun"
		elif (hasSuit):
			animated_sprite_2d.animation = "astro_idle"
		elif (hasBigGun()):
			animated_sprite_2d.animation = "idle_biggun"
		elif (hasSmallGun()):
			animated_sprite_2d.animation = "idle_gun"
		else:
			animated_sprite_2d.animation = "idle"
	animated_sprite_2d.play()

# Setter for guns
func getSmallGun():
	gun = "small"
	objectives[0].hide()
	objectives[1].show()

func getBigGun():
	gun = "big"
	shoot_interval.set_wait_time(0.1)

# Getter for guns
func hasSmallGun():
	return gun == "small"

func hasBigGun():
	return gun == "big"

# Setter for suit
func getSuit():
	hasSuit = true
	health = 5
	for h in 5:
		health_bar[h].show()
	shield_panel.show()

# decrease health by x
func decrease_health(x):
	if (hasSuit && shield > 0):
		shield -= x
		shield_bar[shield].hide()
	else:
		health -= x
		for h in 5:
			if h < health:
				health_bar[h].show()
			else:
				health_bar[h].hide()
		if (health <= 0):
			get_tree().set_pause(true)
			game_over_panel.show()

# enable dodging mechanic
func enableDodge():
	canShoot = false
	isDodging = true
	
	# hitbox handling
	normal_hit_box.set_deferred("disabled", true)
	dodge_hit_box.set_deferred("disabled", false)

# disable dodging mechanic
func disableDodge():
	canShoot = true
	isDodging = false
	
	# hitbox handling
	normal_hit_box.set_deferred("disabled", false)
	dodge_hit_box.set_deferred("disabled", true)

# heading up objective
func _on_objective_3_body_entered(_body: Node2D) -> void:
	if !isOnLevelTwo:
		isOnLevelTwo = true
		objectives[1].hide()
		objectives[2].show()

#boss fight objective
func _on_objective_6_body_entered(_body: Node2D) -> void:
	if !isOnUnderLevel:
		objectives[4].hide()
		objectives[5].show()
