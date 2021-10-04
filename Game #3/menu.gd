extends Node2D


func _ready():
	get_tree().connect("network_peer_connected", self, "_connected")


func _on_singleplayer_pressed():
	var game = preload("res://game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()


func _on_join_button_pressed():
	var client = NetworkedMultiplayerENet.new()
	client.create_client("127.0.0.1", 8080)
	get_tree().set_network_peer(client)


func _on_host_button_pressed():
	var server = NetworkedMultiplayerENet.new()
	server.create_server(8080, 2)
	get_tree().set_network_peer(server)
	
	
func _connected(client_id):
	Singleton.user_id = client_id
	var game = preload("res://game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
