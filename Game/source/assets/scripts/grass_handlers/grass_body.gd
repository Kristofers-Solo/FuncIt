extends Area2D

var reacted = false
var reactionComplete = true
var state = false
var activeAnimation = "idle"
var playingLoop = true

func _process(delta):
	if reacted == true:
		playingLoop = false
		reactionComplete = false
		if state == false:
			activeAnimation = "transition_down"
			reacted = false
			state = true
		else:
			activeAnimation = "transition_up"
			reacted = false
			state = false
	else:
		if reactionComplete == true:
			if state == false:
				activeAnimation = "idle"
			else:
				activeAnimation = "idle_down"
	if activeAnimation == "transition_down" or activeAnimation == "transition_up":
		$trinity_site_level_grass_type_2_animated.play(activeAnimation)
		reactionComplete = true

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		reacted = true
	pass 

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		reacted = true
	pass

func _on_trinity_site_level_grass_type_2_animated_animation_finished():
	if reactionComplete == false:
		reactionComplete = true
	$trinity_site_level_grass_type_2_animated.play(activeAnimation)
	pass
	
