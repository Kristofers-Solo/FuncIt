extends Node2D

var current_spawn_location_instance_number = 1
var current_player_location_instance_number = null

var globalActivePhase = null

var timer = 0
var begunTutorial = false
var finishedMovementZone = false
var finishedJumpZone = false
var finishedAiming = false
var botCount = 0
var botsActivated = false
var finishedTutorial = false

var ts_bot = preload("res://source/entities/ts_bot/ts_bot.tscn")

func _ready() -> void:
	for player in PersistentNodes.get_children():
			Global.get("killed_players").append(player)
	$controls/user_input/controls/ready_button.hide()
	$controls/user_input/controls/skip_button.hide()
	$controls/timer/phase.text = "Tutorial"
# warning-ignore:return_value_discarded
	$controls.modulate[3] = 0
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	if get_tree().is_network_server():
		setup_player_positions()
	$win_lose_screen.show()
	$win_lose_screen/Panel/Label.text = "Tutorial"
	$win_lose_screen/Panel/Label2.show()
	$win_lose_screen/Panel/Label2.text = "Press ENTER to begin or ESC to skip"

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
	if Input.is_action_pressed("esc") and not begunTutorial:
		Network._server_leave()
		get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")
	if Input.is_action_pressed("enter") and not begunTutorial:
		$win_lose_screen.modulate[3] = 0
		begunTutorial = true
		Global.get("killed_players").clear()
	if Input.is_action_pressed("enter") and finishedAiming:
		finishedTutorial = true

func begin_tutorial():
	# Reset initial setup
	if timer < 2:
		finishedJumpZone = false
		finishedMovementZone = false
	# Request to start tutorial.
	# Show a movement target to test ( A / D / SHIFT )
	if not finishedMovementZone and begunTutorial: $simpleTargetZone_basic.show()
	else: $simpleTargetZone_basic.hide()
	if not finishedJumpZone and finishedMovementZone: $simpleTargetZone_jump.show()
	else: $simpleTargetZone_jump.hide()
	if finishedJumpZone and finishedMovementZone and $controls.modulate[3] < 1 and not finishedAiming: 
		$controls.modulate[3] += 0.1
		$weaponInstruction.show()
		if botCount < 6:
			var bot = ts_bot.instance()
			add_child(bot)
			connect("bot_died", bot, "bot_died")
			bot.global_position = $bot_spawn_locations.get_child(botCount).global_position
			botCount += 1
			botsActivated = true
	if botsActivated and botCount == 0:
		finishedAiming = true
		for player in PersistentNodes.get_children():
			Global.get("killed_players").append(player)
	if finishedAiming:
		if $controls.modulate[3] > 0: $controls.modulate[3] -= 0.1
		$win_lose_screen/Panel/Label.text = "Complete"
		$win_lose_screen/Panel/Label2.show()
		$win_lose_screen/Panel/Label2.text = "Press ENTER to continue"
		if $win_lose_screen.modulate[3] < 1: $win_lose_screen.modulate[3] += 0.1
	if finishedTutorial: 
		Global.get("killed_players").clear()
		Network._server_leave()
		get_tree().change_scene("res://source/scenes/GUI/main_menu.tscn")


func _on_simpleTargetZone_jump_zone_entered():
	finishedJumpZone = true


func _on_simpleTargetZone_basic_zone_entered():
	finishedMovementZone = true


func bot_died():
	if botsActivated: botCount -= 1
