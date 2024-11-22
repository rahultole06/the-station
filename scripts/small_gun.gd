# Made by: Rahul M. Tole
# Class: Logic for the gun pickup mechanic
extends Area2D

# Get references to other objects
@onready var gun_panel: Panel = %GunPanel
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D

var clickable = false

# Used to display pickup dialogue in front of storage box
func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D" && !body.hasSmallGun()):
		gun_panel.show()
		clickable = true

# Gun pickup logic 
func _process(delta: float) -> void:
	var e_pressed = Input.is_action_just_pressed("interact")
	if (e_pressed == true && clickable):
			character_body_2d.getSmallGun()
			gun_panel.hide()

# Hide pickup dialogue if player walks away without picking gun
func _on_body_exited(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		gun_panel.hide()
		clickable = false
