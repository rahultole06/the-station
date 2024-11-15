# Made by: Rahul M. Tole
# Class: Alien enemy of tier 1
extends CharacterBody2D

var isLeft = false # stores direction alien is facing
var speed = 70 # alien speed
var direction = 1 # used for left right momvement
var health = 10

# reference to objects
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

# decrease health by x
func decrease_health(x):
	health -= x
	if (health == 0):
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x = delta * speed * direction
	translate(velocity)
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
	
	# Change sprite based on action
	if abs(velocity.x) > 1: # idle player sprite
		animated_sprite_2d.animation = "walking"
	else: # walking sprite
		animated_sprite_2d.animation = "idle"
	
# Used to reverse direction
func _on_timer_timeout() -> void:
	direction *= -1
