extends Node2D

func _ready() -> void:
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")


func _player_disconnected(id) -> void:
	if Players.has_node(str(id)):
		Players.get_node(str(id)).username_text_instance.queue_free()
		Players.get_node(str(id)).queue_free()
