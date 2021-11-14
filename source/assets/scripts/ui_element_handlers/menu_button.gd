extends TextureButton


func _process(_delta) -> void:
	if Input.is_action_just_pressed("esc") and get_tree().get_current_scene().get_child(2).get_children() == []:
# warning-ignore:return_value_discarded
		Global.instance_node(load("res://source/scenes/OVERLAY/elements/menu_button_overlay.tscn"), Global.ui)
	elif Input.is_action_just_pressed("esc") and get_tree().get_current_scene().get_child(2).get_children() != [] and not get_tree().get_current_scene().get_child(2).get_child(0).is_visible_in_tree():
		get_tree().get_current_scene().get_child(2).get_child(0).show()
	elif Input.is_action_just_pressed("esc") and get_tree().get_current_scene().get_child(2).get_children() != [] and get_tree().get_current_scene().get_child(2).get_child(0).is_visible_in_tree():
		get_tree().get_current_scene().get_child(2).get_child(0).hide()


func _on_menu_button_pressed():
# warning-ignore:return_value_discarded
	Global.instance_node(load("res://source/scenes/OVERLAY/elements/menu_button_overlay.tscn"), Global.ui)
