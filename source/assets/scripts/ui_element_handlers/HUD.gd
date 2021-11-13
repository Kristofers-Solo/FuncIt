extends Node2D

var player_following = null
var value = "" setget value_set

var distanceToPlayerOffset = -150

onready var health_bar = $health_bar


func _process(delta: float) -> void:
	if player_following != null:
		global_position = player_following.global_position + Vector2(0,distanceToPlayerOffset).rotated(player_following.rotation)


func value_set(new_text) -> void:
	value = new_text
	health_bar.value = value
