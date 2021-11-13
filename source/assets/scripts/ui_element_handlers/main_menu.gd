extends Control


func _on_play_pressed():
	get_tree().change_scene("res://source/scenes/GUI/sinplayer_setup.tscn")


func _on_LAN_party_pressed():
	get_tree().change_scene("res://source/scenes/GUI/network_setup.tscn")


func _on_exit_pressed():
	get_tree().quit()
