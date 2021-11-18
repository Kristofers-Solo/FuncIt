extends Node2D


func _on_respawn_pressed():
#	self.hide()
	for player in PersistentNodes.get_children():
		if player.is_in_group("Player"):
			player.rpc("enable_playground")


func _on_exit_pressed():
	Network._server_leave()
	get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")
	Global.killed_players.clear()
