extends Node2D

var player_following = null
var text = "" setget text_set

var distanceToPlayerOffset = -100

onready var label = $Label


func _process(delta: float) -> void:
	if player_following != null:
		global_position = player_following.global_position + Vector2(0,distanceToPlayerOffset).rotated(player_following.rotation)


func text_set(new_text) -> void:
	text = new_text
	label.text = text
