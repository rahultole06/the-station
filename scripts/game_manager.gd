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
