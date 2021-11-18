extends Node

var inputState = {}

func _init() -> void:
	inputState = {
		"right": false,
		"left": false,
		"up": false,
		"down": false,
		"debug": false,
		"boost": false,
		"enter": false,
		"r_inc": false,
		"r_dec": false,
		"shoot": false
	}
	pass

func update(clientPhase, player):
	inputState = {
		"right": Input.is_action_pressed("input_right"),
		"left": Input.is_action_pressed("input_left"),
		"up": Input.is_action_pressed("input_up"),
		"down": Input.is_action_pressed("input_down"),
		"debug": Input.is_action_pressed("input_debug"),
		"boost": Input.is_action_pressed("input_shift"),
		"enter": Input.is_action_pressed("input_enter"),
		"r_inc": Input.is_action_pressed("rotation_increase"),
		"r_dec": Input.is_action_pressed("rotation_decrease"),
		"shoot": Input.is_action_pressed("input_shoot")
	}
	if clientPhase != null and clientPhase["active"] != null:
		if clientPhase["active"]["phase_id"] == 0:
			inputState["r_inc"] = false
			inputState["r_dec"] = false
			inputState["shoot"] = false
		elif clientPhase["active"]["phase_id"] == 1:
			inputState["left"] = false
			inputState["right"] = false
			inputState["up"] = false
			inputState["down"] = false
			inputState["shoot"] = false
		elif clientPhase["active"]["phase_id"] == 2:
			inputState["left"] = false
			inputState["right"] = false
			inputState["up"] = false
			inputState["down"] = false
			inputState["r_inc"] = false
			inputState["r_dec"] = false
		else:
			inputState  = {
				"right": false,
				"left": false,
				"up": false,
				"down": false,
				"debug": false,
				"boost": false,
				"enter": false,
				"r_inc": false,
				"r_dec": false,
				"shoot": false
			}
	if player in Global.get("killed_players"):
		inputState  = {
				"right": false,
				"left": false,
				"up": false,
				"down": false,
				"debug": false,
				"boost": false,
				"enter": false,
				"r_inc": false,
				"r_dec": false,
				"shoot": false
			}
	return inputState
