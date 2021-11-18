extends Control

var player = load("res://source/entities/player/player_node.tscn")

func _ready() -> void:
	Global.alive_players.append(self)
	Network.current_player_username = "You"
	Network.create_server()
	instance_player(get_tree().get_network_unique_id())
	rpc("switch_to_game")


func instance_player(id) -> void:
	var player_instance = Global.instance_node_at_location(player, PersistentNodes, Vector2())
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	player_instance.username = "You"

sync func switch_to_game() -> void:
	for child in PersistentNodes.get_children():
		if child.is_in_group("Player"):
			child.update_shoot_mode(true)
	get_tree().change_scene("res://source/scenes/GAME/game_tutorial.tscn")

