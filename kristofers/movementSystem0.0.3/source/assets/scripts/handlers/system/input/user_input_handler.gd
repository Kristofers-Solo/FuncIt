extends Node

var inputState = {}

func _init() -> void:
	inputState = {
		"right": false,
		"left": false,
		"up": false,
		"down": false,
		"debug": false
	}
	pass

func update():
	inputState = {
		"right": Input.is_action_pressed("input_right"),
		"left": Input.is_action_pressed("input_left"),
		"up": Input.is_action_pressed("input_up"),
		"down": Input.is_action_pressed("input_down"),
		"debug": Input.is_action_pressed("input_debug_toggle")
	}
	return inputState
