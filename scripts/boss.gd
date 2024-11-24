# Made by: Rahul M. Tole
# Class: Alien enemy of tier 1
extends CharacterBody2D

var speed = 70 # alien speed
var health = 100
var hit = false # checks if alien is hit with bullet
var engage = false # checks if alien is approaching
var attacking = false
var retreating = false  # Tracks if the alien is retreating
var min_proximity = 70  # Minimum distance from the player
var has_attacked = false  # Ensures the alien attacks only once per engagement

# reference to objects
@onready var boss_sprite: AnimatedSprite2D = %BossSprite
@onready var character_body_2d: CharacterBody2D = %CharacterBody2D
@onready var attack_timer: Timer = %AttackTimer
@onready var hit_effect_timer: Timer = %HitEffectTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Health checker
	if (health <= 0):
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
	
	# Calculate the distance to the player
	var distance_to_player = character_body_2d.position.distance_to(position)
	
	# Movement logic
	if retreating or distance_to_player < min_proximity:
		velocity.x += -speed * delta  # Move away from the player
	elif !attacking && !engage or distance_to_player <= min_proximity:
		velocity.x = 0  # Stop moving if attacking or not engaged
	else:
		velocity.x += speed * delta  # Move toward the player

	move_and_slide()
	
	# disable collision with player on ladder
	if (character_body_2d.onLadder):
		add_collision_exception_with(character_body_2d)
	else:
		remove_collision_exception_with(character_body_2d)
	
	updateAnimation()
	checkAttack()

# Change sprite based on action
func updateAnimation():	
	if attacking:
		boss_sprite.animation = "attack_hit" if hit else "attack"
	else:
		boss_sprite.animation = "idle_hit" if hit else "idle"

# decrease health by x
func decrease_health(x: int) -> void:
	health -= x
	hit = true
	hit_effect_timer.start()

func checkAttack():
	if character_body_2d == null:
		engage = false
		attacking = false
		return

	# Check if the player is in line of sight
	var inLineOfSight = (character_body_2d.position.y >= position.y - 45) && (character_body_2d.position.y <= position.y + 59)
	var distance_to_player = character_body_2d.position.distance_to(position)

	engage = inLineOfSight and distance_to_player > min_proximity  # Engage only if outside the safe zone

	# Check if the player is in proximity
	var inProximity = abs(character_body_2d.position.x - position.x) <= 90

	# If the player is dodging, start retreating
	if character_body_2d.isDodging && !attacking:
		start_retreat()
	elif engage and inProximity and !has_attacked:
		perform_attack()

# Perform the attack on the player and retreat
func perform_attack():
	if !attacking:
		attacking = true
		has_attacked = true  # Prevent multiple attacks during the same engagement
		
		boss_sprite.animation = "attack"
		boss_sprite.play()
		boss_sprite.animation_finished.connect(on_attack_animation_finished)

# Callback when attack animation finishes
func on_attack_animation_finished():
	if attacking:
		# Apply damage to the player
		if character_body_2d != null:
			character_body_2d.decrease_health(1)

		# Start retreating after the attack
		start_retreat()

# Trigger retreating behavior for a set duration
func start_retreat():
	retreating = true
	attacking = false
	await get_tree().create_timer(1.5).timeout  # Retreat for 1.5 seconds
	has_attacked = false  # Reset attack state after retreat
	engage = false
	retreating = false

# Brings alien look back to normal after being hit
func _on_hit_effect_timer_timeout() -> void:
	hit = false
