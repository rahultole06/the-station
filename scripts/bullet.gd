# Made by: Rahul M. Tole
# Class: Bullet mechanics
extends Area2D

# Get references to other objects
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

# instance variables
var speed = 300 # bullet speed
var direction = 1 # used to handle shoot direction
var velocity = Vector2() # bullet motion
var audioPlayed = false # checks if audio played

func _physics_process(delta):
	velocity.x = speed * delta * direction # motion of bullet * direction (-1 is left, 1 is right)
	if (direction == -1): # handle sprite direction
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	translate(velocity)

# change direction based on player direction
func set_direction(dir):
	direction = dir

# bullet hit mechanic
func _on_body_entered(body):
	body.decrease_health(1)
	queue_free()

# destroy bullet if it leaves viewport
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() 
