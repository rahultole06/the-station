# Made by: Rahul M. Tole
# Class: Logic for the gun pickup mechanic
extends Area2D

# Get references to other objects
@onready var gun_panel: Panel = %GunPanel
@onready var game_manager: Node = %GameManager

# Used to display pickup dialogue in front of storage box
func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		if (game_manager.hasGun() == false):
			gun_panel.show()

# Gun pickup logic 
func _process(delta: float) -> void:
	var e_pressed = Input.is_action_just_pressed("interact")
	if (e_pressed == true && gun_panel.visible == true):
			game_manager.getGun()
			gun_panel.hide()

# Hide pickup dialogue if player walks away without picking gun
func _on_body_exited(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		gun_panel.hide()
