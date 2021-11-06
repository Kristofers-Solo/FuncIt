extends Control

var current_spawn_location_instance_number = 1
var current_player_for_spawn_location_number = null
var player = load("res://source/entities/player/player_node.tscn")

export onready var username_text_edit = $multiplayer_configure/username_text_edit


func _process(delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")


func _on_create_server_pressed():
	if username_text_edit.text != "":
		Network.current_player_username = username_text_edit.text
		Network.create_server()
		get_tree().change_scene("res://source/scenes/GUI/lobby.tscn")


func _on_join_server_pressed():
	if username_text_edit.text != "":
		Global.instance_node(load("res://source/scenes/GUI/server_handlers/server_browser.tscn"), self)


func instance_player(id) -> void:
	var player_instance = Global.instance_node_at_location(player, PersistentNodes, get_node("spawn_locations/" + str(current_spawn_location_instance_number)).global_position)
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	player_instance.username = username_text_edit.text
	current_spawn_location_instance_number += 1


func _on_return_pressed():
	get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")


func enter_username():
	pass
