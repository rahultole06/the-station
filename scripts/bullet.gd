# Made by: Rahul M. Tole
# Class: Bullet mechanics
extends Area2D

# Get references to other objects
@onready var boundary: TileMapLayer = %Boundary
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

# instance variables
var speed = 300 # bullet speed
var direction = 1 # used to handle shoot direction
var velocity = Vector2() # bullet motion

func _physics_process(delta):
	velocity.x = speed * delta * direction # motion of bullet * direction (-1 is left, 1 is right)
	if (direction == -1): # handle sprite direction
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	translate(velocity)

func set_direction(dir): # change direction based on player direction
	direction = dir

func _on_body_entered(body): # bullet hit mechanic
	body.decrease_health(2)
	queue_free()
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void: # distroy bullet if it leaves viewport
	queue_free() 
