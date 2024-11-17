# Made by: Rahul M. Tole
# Class: Game over screen
extends Node

@onready var game_over_panel: Panel = %GameOverPanel

# restart button logic
func _on_restart_pressed() -> void:
	get_tree().paused = false
	game_over_panel.hide()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# main menu button logic
func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	game_over_panel.hide()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
