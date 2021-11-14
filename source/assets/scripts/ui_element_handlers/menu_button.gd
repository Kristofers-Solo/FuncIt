extends TextureButton

#func _process(delta) -> void:
#	if Input.is_action_just_pressed("esc"):
#		Global.instance_node(load("res://source/scenes/OVERLAY/elements/menu_button_overlay.tscn"), Global.ui)

func _on_menu_button_pressed():
	Global.instance_node(load("res://source/scenes/OVERLAY/elements/menu_button_overlay.tscn"), Global.ui)
