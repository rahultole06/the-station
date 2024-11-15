# Made by: Rahul M. Tole
# Class: Handles core gameplay mechanics
extends Node

# Store reference to other objects
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D

# instance variables
var gun = false # checks if player has gun
var health = 5 # player health

# Setter/Getter for gun 
func getGun():
	gun = true
	
func hasGun():
	return gun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
