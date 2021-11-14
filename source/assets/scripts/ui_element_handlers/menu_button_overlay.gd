extends Control


func _process(delta) -> void:
#	print(str(self))
	if Input.is_action_just_pressed("esc"):
		hide()


func _on_return_to_game_pressed():
	hide()


func _on_return_to_main_menu_pressed():
	Network._server_leave()
	get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")


func _on_exit_game_pressed():
	get_tree().quit()


func _player_disconnected(id) -> void:
	if PersistentNodes.has_node(str(id)):
		PersistentNodes.get_node(str(id)).username_text_instance.queue_free()
		PersistentNodes.get_node(str(id)).health_bar_instance.queue_free()
		PersistentNodes.get_node(str(id)).queue_free()
