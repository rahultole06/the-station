# Made by: Rahul M. Tole
# Class: Game audio handling
# Note: Not all audio is handled here for convenience, some are done in their respective scripts
extends Node

# reference to other objects
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D
@onready var walking_noise: AudioStreamPlayer = %WalkingNoise
@onready var dodge_noise: AudioStreamPlayer = %DodgeNoise
@onready var ladder_noise: AudioStreamPlayer = %LadderNoise
@export var enemies : Array[Node]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	walking_play = abs(character_body_2d.velocity.x) >= 10
	ladder_play = abs(character_body_2d.velocity.y) >= 10
	dodge_play = character_body_2d.isDodging
	for e in enemies:
		if e != null && abs(e.velocity.x) >= 7:
			e.walk_noise.play()
	playAudio()

# Audio handling
var walking_play = false
var walking_isPlaying = false
var ladder_play = false
var ladder_isPlaying = false
var dodge_play = false
var dodge_isPlaying = false
func playAudio():
	if walking_play && !walking_isPlaying:
		walking_noise.play()
		walking_isPlaying = true
	elif !walking_play:
		walking_noise.stop()
		walking_isPlaying = false
		
	if ladder_play && !ladder_isPlaying:
		ladder_noise.play()
		ladder_isPlaying = true
	elif !ladder_play:
		ladder_noise.stop()
		ladder_isPlaying = false

	if dodge_play && !dodge_isPlaying:
		dodge_noise.play()
		dodge_isPlaying = true
	elif !dodge_play:
		dodge_noise.stop()
		dodge_isPlaying = false
