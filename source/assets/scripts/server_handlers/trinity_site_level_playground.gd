extends Node2D

var current_spawn_location_instance_number = 1
var current_player_location_instance_number = null

var globalActivePhase = null

func _ready() -> void:
	$controls/user_input/controls/ready_button.hide()
	$controls/user_input/controls/skip_button.hide()
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	if get_tree().is_network_server():
		setup_player_positions()

func setup_player_positions() -> void:
	for player in PersistentNodes.get_children():
		if player.is_in_group("Player"):
			for spawn_location in $spawn_locations.get_children():
				if int(spawn_location.name) == current_spawn_location_instance_number and current_player_location_instance_number != player:
					player.rpc("update_position", spawn_location.global_position)
					current_spawn_location_instance_number += 1
					current_player_location_instance_number = player


func _player_disconnected(id) -> void:
	if PersistentNodes.has_node(str(id)):
		PersistentNodes.get_node(str(id)).username_text_instance.queue_free()
		PersistentNodes.get_node(str(id)).health_bar_instance.queue_free()
		PersistentNodes.get_node(str(id)).queue_free()
