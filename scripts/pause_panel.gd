# Made by: Rahul M. Tole
# Class: Pause panel in-game
extends Panel

func _physics_process(_delta: float) -> void:
	# input handling
	if Input.is_action_just_pressed("pause"):
		if (!is_visible()): # if not visible
			get_tree().set_pause(true)
			set_visible(true)
		else: # resume game
			get_tree().set_pause(false)
			set_visible(false)

# Panel buton handling
func _on_resume_pressed() -> void:
	set_visible(false)
	get_tree().set_pause(false)

func _on_main_menu_pressed() -> void:
	set_visible(false)
	get_tree().set_pause(false)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
