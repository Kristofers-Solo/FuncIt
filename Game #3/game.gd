extends Node2D

onready var player_pos_1 = $PostitionPlayer_1
onready var player_pos_2 = $PostitionPlayer_2

func _ready():
	var player_1 = preload("res://player.tscn").instance()
	player_1.set_name(str(get_tree().get_network_unique_id()))
	player_1.set_network_master(get_tree().get_network_unique_id())
	player_1.global_transform = player_pos_1.global_transform
	add_child(player_1)
	
	var player_2 = preload("res://player.tscn").instance()
	player_2.set_name(str(Singleton.user_id))
	player_2.set_network_master(Singleton.user_id)
	player_2.global_transform = player_pos_2.global_transform
	add_child(player_2)
