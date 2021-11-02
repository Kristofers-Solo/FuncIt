extends Area2D

var reacted = false

func _on_Area2D_body_entered(body):
	print("Entered")
	if body.is_in_group("Player"):
		$trinity_site_level_grass_type_2_animated.play("react")
		reacted = true
	pass 

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player") and reacted == true:
		$trinity_site_level_grass_type_2_animated.play("idle")
		reacted = false
	pass
