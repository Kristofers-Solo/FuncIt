extends Node

var userState = {}

var rotationalTracker = 0

func rotateBy(amount):
	rotationalTracker += amount
	if rotationalTracker == 361: rotationalTracker = 1
	elif rotationalTracker == -361: rotationalTracker = -1

func update(positionUpdate):
	userState = preload("res://source/assets/scripts/handlers/character/player/player_node_handler.gd").new().statePassback()
	# IF necessary process and update and correct userState
	userState["node_global_position"] = positionUpdate
	userState["rotation"] = rotationalTracker
	return userState
