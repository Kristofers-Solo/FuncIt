extends Node2D


func _on_respawn_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")
