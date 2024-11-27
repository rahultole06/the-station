extends Area2D

# Get references to other objects
@onready var suit_panel: Panel = %SuitPanel
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D
@onready var suit_noise: AudioStreamPlayer = %SuitNoise

var clickable = false

# Used to display pickup dialogue in front of storage box
func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D" && !body.hasSuit):
		suit_panel.show()
		clickable = true

# Gun pickup logic 
func _process(_delta: float) -> void:
	var e_pressed = Input.is_action_just_pressed("interact")
	if (e_pressed == true && clickable):
			suit_noise.play()
			character_body_2d.getSuit()
			clickable = false
			suit_panel.hide()

# Hide pickup dialogue if player walks away without picking gun
func _on_body_exited(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		suit_panel.hide()
		clickable = false
