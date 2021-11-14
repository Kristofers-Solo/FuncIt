extends Node2D

var player_following = null
var text = "" setget text_set

var distanceToPlayerOffset = -150

onready var label = $Label


func _process(_delta) -> void:
	if player_following != null:
		global_position = player_following.global_position + Vector2(0,distanceToPlayerOffset).rotated(player_following.rotation)


func text_set(new_text) -> void:
	text = new_text
	label.text = text
