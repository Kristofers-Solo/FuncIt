extends Node

var userState = {}

func _init() -> void:
	userState = {
		"state": false
	}
	pass

func update():
	userState = {
		"state": true
	}
	return userState
