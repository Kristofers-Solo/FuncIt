extends TextureButton


func _process(_delta) -> void:
	if get_tree().get_current_scene().get_name() == "network_setup":
		if Input.is_action_just_pressed("esc") and get_tree().get_current_scene().get_child(2).get_children() == [] and not get_tree().get_current_scene().get_child(1).is_visible_in_tree():
			Global.instance_node(load("res://source/scenes/OVERLAY/elements/menu_button_overlay.tscn"), Global.ui)
	else: 
		if Input.is_action_just_pressed("esc") and get_tree().get_current_scene().get_child(2).get_children() == []:
			Global.instance_node(load("res://source/scenes/OVERLAY/elements/menu_button_overlay.tscn"), Global.ui)


func _on_menu_button_pressed():
# warning-ignore:return_value_discarded
	Global.instance_node(load("res://source/scenes/OVERLAY/elements/menu_button_overlay.tscn"), Global.ui)
