extends Control


func _process(_delta) -> void:
	if Input.is_action_just_pressed("enter"):
		_on_ok_pressed()


func _on_ok_pressed():
	get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")


func set_text(text) -> void:
	$Label.text = text
