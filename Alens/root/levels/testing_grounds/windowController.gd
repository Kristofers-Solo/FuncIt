extends Node2D

func _ready():
	var windowExpectedWidth = $StaticBody2D/terrain_sprite.texture.get_width() * $StaticBody2D/terrain_sprite.scale.x
	var windowExpectedHeight = $StaticBody2D/terrain_sprite.texture.get_height() * $StaticBody2D/terrain_sprite.scale.y
	OS.set_window_size(Vector2(windowExpectedWidth, windowExpectedHeight))
	pass
