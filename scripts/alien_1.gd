# Made by: Rahul M. Tole
# Class: Alien enemy of tier 1
extends CharacterBody2D

const bullet = preload("res://scenes/bullet.tscn")

var isLeft = false # stores direction alien is facing
var speed = 70 # alien speed
var direction = 1 # used for left right momvement
var health = 5
var hit = false # checks if alien is hit with bullet
var shooting = false # checks if alien is shooting
var isVisible = false

# reference to objects
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D
@onready var hit_effect_timer: Timer = $HitEffectTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var audio_handler: Node = %AudioHandler
@onready var shoot_noise: Node = audio_handler.get_child(0).get_child(1)
@onready var noise_timer: Timer = %NoiseTimer
@onready var alien_noise: AudioStreamPlayer2D = %AlienNoise
@onready var perish_noise: AudioStreamPlayer2D = %PerishNoise
@onready var perish_timer: Timer = %PerishTimer
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var walk_noise: AudioStreamPlayer2D = %WalkNoise

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Health checker
	if (health == 0):
		health = -1 # makes sure this block runs only once
		perish_noise.play()
		animated_sprite_2d.hide()
		collision_shape_2d.set_deferred("disabled", true)
		shoot_timer.stop()
		shooting = false
		perish_timer.start()
		
	if not shooting:
		velocity.x = delta * speed * direction
		translate(velocity)
	else: # don't move if shooting
		velocity.x = 0
	
	# disable collision with player on ladder
	if (character_body_2d.onLadder):
		add_collision_exception_with(character_body_2d)
	else:
		remove_collision_exception_with(character_body_2d)
	
	updateAnimation()
	checkShoot()

# Change sprite based on action
func updateAnimation():
	# Check if the alien is moving left or right
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
	
	if abs(velocity.x) > 1: # idle player sprite
		if (hit == false):
			animated_sprite_2d.animation = "walking"
		else:
			animated_sprite_2d.animation = "walking_hit"
	else: # walking sprite
		if (hit == false):
			animated_sprite_2d.animation = "idle"
		else:
			animated_sprite_2d.animation = "idle_hit"

# decrease health by x
func decrease_health(x):
	health -= x
	hit = true
	hit_effect_timer.start()

func checkShoot():
	var leftOf = character_body_2d.position.x < position.x
	var inLineOfSight = (character_body_2d.position.y >= position.y - 45) && (character_body_2d.position.y <= position.y + 59)
	if character_body_2d != null && isVisible && inLineOfSight && ((leftOf && isLeft) || (!leftOf && !isLeft)):
		shooting = true
	else:
		shooting = false

# Used to reverse direction
func _on_direction_timer_timeout() -> void:
	if (shooting != true): # doesn't change direction if shooting
		direction *= -1

# Brings alien look back to normal after being hit
func _on_hit_effect_timer_timeout() -> void:
	hit = false

# checks if player is close to alien
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	isVisible = true
	shoot_timer.start()
	alien_noise.play()


func _on_shoot_timer_timeout() -> void:
	if (shooting):
		shoot_noise.play() # shoot audio
		var b = bullet.instantiate()
		if sign($Marker2D.position.x) == 1:
			b.set_direction(1)
		else:
			b.set_direction(-1)
		get_parent().add_child(b)
		b.show()
		b.position = $Marker2D.global_position

# play alien noise
func _on_noise_timer_timeout() -> void:
	if isVisible:
		alien_noise.play()

# alien death
func _on_perish_timer_timeout() -> void:
	queue_free()
