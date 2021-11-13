extends Control

var player = load("res://source/entities/player/player_node.tscn")

onready var username_text_edit = $popup_screen/panel/username_text_edit


func _ready() -> void:
	username_text_edit.call_deferred("grab_focus")


func _process(delta) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")


#func _player_connected(id) -> void:
#	print("Player " + str(id) + " has connected")
#
#
#func _connected_to_server() -> void:
#	yield(get_tree().create_timer(0.1), "timeout")
#
#
#func _on_start_game_pressed():
#	rpc("switch_to_game")


func _on_confirm_pressed():
	if username_text_edit.text != "":
		Network.current_player_username = username_text_edit.text
		Network.create_server()
		rpc("switch_to_game")


sync func switch_to_game() -> void:
	for child in PersistentNodes.get_children():
		if child.is_in_group("Player"):
			child.update_shoot_mode(true)
	
	get_tree().change_scene("res://source/levels/trinity_site/trinity_site_level.tscn")




func _on_return_pressed():
	get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")

