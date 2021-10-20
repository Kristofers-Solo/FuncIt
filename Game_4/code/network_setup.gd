extends Control

var player = load("res://scenes/player.tscn")

onready var multiplayer_config_ui = $multiplayer_configure
onready var username_text_edit = $multiplayer_configure/username_text_edit
onready var device_ip_address = $CanvasLayer/device_ip_address
onready var start_game = $CanvasLayer/start_game


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_address.text = Network.ip_address
	
	if get_tree().network_peer != null:
		pass
	else:
		start_game.hide()


func _process(delta: float) -> void:
	if get_tree().network_peer != null:
		if get_tree().get_network_connected_peers().size() >= 0 and get_tree().is_network_server():
			start_game.show()
		else:
			start_game.hide()


func _player_connected(id) -> void:
	print("Player " + str(id) + " has connected")
	instance_player(id)


func _player_disconnected(id) -> void:
	print("Player " + str(id) + " has disconnected")
	if Players.has_node(str(id)):
		Players.get_node(str(id)).username_text_instance.queue_free()
		Players.get_node(str(id)).queue_free()


func _on_create_server_pressed():
	if username_text_edit.text != "":
		Network.current_player_username = username_text_edit.text
		multiplayer_config_ui.hide()
		Network.create_server()
		instance_player(get_tree().get_network_unique_id())


func _on_join_server_pressed():
	if username_text_edit.text != "":
		multiplayer_config_ui.hide()
		username_text_edit.hide()
		Global.instance_node(load("res://scenes/server_browser.tscn"), self)


func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())


func instance_player(id) -> void:
	var player_instance = Global.instance_node_at_location(player, Players, Vector2(rand_range(0, 1920), rand_range(0, 1080)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	player_instance.username = username_text_edit.text


func _on_start_game_pressed():
	rpc("switch_to_game")


sync func switch_to_game() -> void:
	get_tree().change_scene("res://scenes/game.tscn") 
