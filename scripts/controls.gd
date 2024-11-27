# Made by: Rahul M. Tole
# Class: Control scheme menu
extends Node

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
