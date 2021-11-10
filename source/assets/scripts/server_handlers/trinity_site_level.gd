extends Node2D

var current_spawn_location_instance_number = 1
var current_player_location_instance_number = null

var gameControllerStates = {"singleplayer": false, "waiting": true, "allowMove": false, "allowShoot": false, "allowAim": false, "allowInput": false, "allowMenu": true, "simulatingEnvironment": false, "players": {}, "activePlayer": null}
var activePlayerIndicator = "0"
var gameTimer = 0

func _ready() -> void:
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	if get_tree().is_network_server():
		setup_player_positions()

func _process(delta):
	gameTimer += delta
	if not gameControllerStates["singleplayer"]:
		if gameControllerStates["waiting"] and gameControllerStates["players"] != {} and not gameControllerStates["simulatingEnvironment"]:
			if gameTimer > 5:
				# Wait for tanks to fall to the ground
				gameControllerStates["allowMove"] = true
				gameControllerStates["activePlayer"] = gameControllerStates["players"][activePlayerIndicator]
				gameControllerStates["waiting"] = false
				gameTimer = 0
		if gameControllerStates["allowMove"]:
			# Get the active player and allow their inputs to have effect.
			print("Awaiting player input and processing it to adjust location and rotation")
			# DO FOR EACH PLAYER - ONE AFTER THE OTHER
		if gameControllerStates["allowAim"] and gameControllerStates["allowInput"]:
			# Get the active player and allow their input into adjusting function.
			print("Awaiting player input and processing it to adjust aim.")
			# DO FOR EACH PLAYER - AT THE SAME TIME
		if gameControllerStates["allowShoot"]:
			# Enable function locking feature and prepare for shooting phase -- simulatingEnvironment = true
			print("Awaiting player function confirmation.")
			# DO FOR EACH PLAYER - AT THE SAME TIME
		if gameControllerStates["simulatingEnvironment"]:
			# Ignore player input, request player weapons to fire the bullets and account for the damages.
			# Reset the cycle back to the move stage if neither player won the game.
			print("Game result: undetermined, returning to move phase.")
	if gameControllerStates["singleplayer"]:
		# Do not interrupt user input -> only request checking for victory.
		print("Singleplayer mode selected, awaiting game result.")

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
		PersistentNodes.get_node(str(id)).queue_free()
