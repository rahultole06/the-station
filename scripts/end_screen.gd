extends Node

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
