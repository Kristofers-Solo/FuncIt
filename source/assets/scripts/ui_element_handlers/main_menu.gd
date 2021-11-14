extends Control


func _on_play_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://source/scenes/GUI/singleplayer_setup.tscn")


func _on_LAN_party_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://source/scenes/GUI/network_setup.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


