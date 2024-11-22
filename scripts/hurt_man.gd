extends Area2D

@onready var gun_panel: Panel = %GunPanel
@onready var hurt_man_sprite: AnimatedSprite2D = %HurtManSprite
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D

var clickable = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (clickable && Input.is_action_just_pressed("interact")):
			hurt_man_sprite.animation = "idle"


func _on_body_entered(body: Node2D) -> void:
	if (body.get_name() == "CharacterBody2D"):
		gun_panel.show()
		clickable = true

func _on_body_exited(body: Node2D) -> void:
	if (body.get_name() == "CharacterBody2D"):
		gun_panel.hide()
		clickable = false