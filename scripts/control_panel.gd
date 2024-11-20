# Made by: Rahul M. Tole
# Class: Handles control panel/door opening mechanics
extends Area2D

# reference to other objects
@onready var door: RigidBody2D = %Door
@onready var door_animation: AnimatedSprite2D = %DoorAnimation
@onready var door_hitbox: CollisionShape2D = %DoorHitbox
@onready var open_hitbox: CollisionShape2D = %OpenHitbox
@onready var control_panel: Panel = %ControlPanel
@onready var control_panel_animation: AnimatedSprite2D = %ControlPanelAnimation

# instance variables
var clickable = false # checks if player is near object
var opened = false # keep door open status

func _ready():
	# keeps open door hitbox off on start
	open_hitbox.set_deferred("disabled", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# input handling only when standing in front of panel
	if (control_panel.visible && Input.is_action_just_pressed("interact")):
		door_animation.animation = "open"
		# hitbox handling
		door_hitbox.set_deferred("disabled", true)
		open_hitbox.set_deferred("disabled", false)
		control_panel_animation.animation = "active"
		opened = true

# checked if player is in front of panel
func _on_body_entered(body: Node2D) -> void:
	clickable = true
	if (!opened):
		control_panel.set_visible(true)

func _on_body_exited(body: Node2D) -> void:
	clickable = false
	control_panel.set_visible(false)
