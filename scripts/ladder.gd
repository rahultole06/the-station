# Made by: Rahul M. Tole
# Class: Player mechanic logic
extends Area2D

# Reference to other objects
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D

# allows player to know when on ladder
func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		character_body_2d.onLadder = true

# allows player to know when off ladder
func _on_body_exited(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		character_body_2d.onLadder = false
