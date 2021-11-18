extends Node2D

var current_spawn_location_instance_number = 1
var current_player_location_instance_number = null
var time = 20
onready var phase = $controls/timer/phase
onready var timer = $controls/timer/timer
var overlay = Global.instance_node(load("res://source/scenes/OVERLAY/elements/menu_button_overlay.tscn"), Global.ui)

var globalActivePhase = null

func _ready() -> void:
	Global.mode = 2
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	if get_tree().is_network_server():
		setup_player_positions()
	Global.start_game(true)


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


func _process(_delta):
	if Global.get_current_phase()["active"] != null and Global.get_current_phase()["active"]["start_time"] != null: 
		if Global.get_current_phase()["active"]["length"] - abs(OS.get_time()["second"] + OS.get_time()["minute"] * 60 - Global.get_current_phase()["active"]["start_time"]["second"] - Global.get_current_phase()["active"]["start_time"]["minute"] * 60) < 10:
			$controls/timer/time.text = "00:0"+str(Global.get_current_phase()["active"]["length"] - abs(OS.get_time()["second"] + OS.get_time()["minute"] * 60 - Global.get_current_phase()["active"]["start_time"]["second"] - Global.get_current_phase()["active"]["start_time"]["minute"] * 60))
		else:
			$controls/timer/time.text = "00:"+str(Global.get_current_phase()["active"]["length"] - abs(OS.get_time()["second"] + OS.get_time()["minute"] * 60 - Global.get_current_phase()["active"]["start_time"]["second"] - Global.get_current_phase()["active"]["start_time"]["minute"] * 60))
	globalActivePhase = Global.get_current_phase()
	if globalActivePhase["active"] != null:
		phase.text = str(globalActivePhase["active"]["phase_name"])
