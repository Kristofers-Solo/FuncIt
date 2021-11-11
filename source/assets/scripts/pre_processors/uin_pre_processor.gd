extends Node

var inputState = {}

func _init() -> void:
	inputState = {
		"right": false,
		"left": false,
		"up": false,
		"down": false,
		"debug": false,
		"enter": false,
		"r_inc": false,
		"r_dec": false,
		"shoot": false
	}
	pass

func update():
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
	return inputState
