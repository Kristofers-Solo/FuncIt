extends Label

sync func return_to_lobby():
	get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")


func _on_win_timer_timeout():
	if get_tree().is_network_server():
		rpc("return_to_lobby")
