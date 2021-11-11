extends Control


func _on_play_pressed():
	#get_tree().change_scene("res://source/levels/trinity_site/trinity_site_level.tscn")
	pass


func _on_LAN_party_pressed():
	get_tree().change_scene("res://source/scenes/GUI/network_setup.tscn")


func _on_exit_pressed():
	get_tree().quit()
