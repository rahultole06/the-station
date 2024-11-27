extends Area2D

@onready var gun_panel: Panel = %GunPanel
@onready var hurt_man_sprite: AnimatedSprite2D = %HurtManSprite
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D
@onready var gun_pickup_noise: AudioStreamPlayer = %GunPickupNoise

var clickable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (clickable && Input.is_action_just_pressed("interact")):
		gun_pickup_noise.play()
		hurt_man_sprite.animation = "idle"
		character_body_2d.getBigGun()
		clickable = false
		gun_panel.hide()


func _on_body_entered(body: Node2D) -> void:
	if (body.get_name() == "CharacterBody2D" && !body.hasBigGun()):
		gun_panel.show()
		clickable = true

func _on_body_exited(body: Node2D) -> void:
	if (body.get_name() == "CharacterBody2D"):
		gun_panel.hide()
		clickable = false
