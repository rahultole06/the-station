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
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D
@onready var activate_noise: AudioStreamPlayer = %ActivateNoise

# instance variables
var clickable = false # checks if player is near object
var opened = false # keep door open status

func _ready():
	# keeps open door hitbox off on start
	open_hitbox.set_deferred("disabled", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# input handling only when standing in front of panel
	if (clickable && Input.is_action_just_pressed("interact")):
		activate_noise.play()
		door_animation.animation = "open"
		# hitbox handling
		door_hitbox.set_deferred("disabled", true)
		open_hitbox.set_deferred("disabled", false)
		control_panel_animation.animation = "active"
		clickable = false
		opened = true

# checked if player is in front of panel
func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D" && body.hasSuit && body.hasBigGun() && !opened):
		clickable = true
		control_panel.show()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		clickable = false
		control_panel.hide()
