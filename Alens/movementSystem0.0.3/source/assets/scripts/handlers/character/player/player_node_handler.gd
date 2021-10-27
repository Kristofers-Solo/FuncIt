extends Node2D

func _ready():
	pass

func set_scale(scale):
	$player_body/player_sprite_na.scale = Vector2(scale, scale)
	$player_body/player_sprite.scale = Vector2(scale, scale)
	$player_body/player_collider.scale = Vector2(scale, scale)
	pass
