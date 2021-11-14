extends Control

var player = load("res://source/entities/player/player_node.tscn")

onready var username_text_edit = $popup_screen/panel/username_text_edit


func _ready() -> void:
	username_text_edit.call_deferred("grab_focus")


func _process(delta) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")


func _on_confirm_pressed():
	if username_text_edit.text != "":
		Global.alive_players.append(self)
		Network.current_player_username = username_text_edit.text
		Network.create_server()
		instance_player(get_tree().get_network_unique_id())
		rpc("switch_to_game")


func instance_player(id) -> void:
	var player_instance = Global.instance_node_at_location(player, PersistentNodes, Vector2())
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	player_instance.username = username_text_edit.text


sync func switch_to_game() -> void:
	for child in PersistentNodes.get_children():
		if child.is_in_group("Player"):
			child.update_shoot_mode(true)
	
	get_tree().change_scene("res://source/levels/trinity_site/trinity_site_level_playground.tscn")


func _on_return_pressed():
	get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")

