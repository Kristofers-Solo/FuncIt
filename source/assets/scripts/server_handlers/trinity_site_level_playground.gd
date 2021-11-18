extends Node2D

var current_spawn_location_instance_number = 1
var current_player_location_instance_number = null

var globalActivePhase = null

var timer = 0
var finishedMovementZone = false
var finishedJumpZone = false
var finishedAiming = false
var botCount = 0

var ts_bot = preload("res://source/entities/ts_bot/ts_bot.tscn")

func _ready() -> void:
	$controls/timer/phase.text = "Tutorial"
# warning-ignore:return_value_discarded
	$controls.modulate[3] = 0
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

func _process(delta):
	timer += delta
	begin_tutorial()

func begin_tutorial():
	# Reset initial setup
	if timer < 2:
		finishedJumpZone = false
		finishedMovementZone = false
	# Request to start tutorial.
	# Show a movement target to test ( A / D / SHIFT )
	if not finishedMovementZone: $simpleTargetZone_basic.show()
	else: $simpleTargetZone_basic.hide()
	if not finishedJumpZone and finishedMovementZone: $simpleTargetZone_jump.show()
	else: $simpleTargetZone_jump.hide()
	if finishedJumpZone and finishedMovementZone and $controls.modulate[3] < 1: 
		$controls.modulate[3] += 0.1
		$weaponInstruction.show()
		if botCount < 6:
			var bot = ts_bot.instance()
			add_child(bot)
			bot.global_position = $bot_spawn_locations.get_child(botCount).global_position
			botCount += 1
	# After target destroyed request permission to move on to menu.
	# Remove player before moving on. !!!!!!!!!!!
	
	if finishedMovementZone and finishedJumpZone and finishedAiming and timer > 2: 
		Network._server_leave()
		get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")


func _on_simpleTargetZone_jump_zone_entered():
	finishedJumpZone = true


func _on_simpleTargetZone_basic_zone_entered():
	finishedMovementZone = true
