extends Node2D

func statePassback():
	return {"node_global_position": null, "rotation": null}

func set_scale(scale) -> void:
	$player_body/player_sprite_na.scale = Vector2(scale, scale)
	$player_body/player_sprite.scale = Vector2(scale, scale)
	$player_body/player_collider.scale = Vector2(scale, scale)
	pass
