extends KinematicBody2D


var velocity = Vector2(1, 1)

func _process(delta):
	var collision = move_and_collide(velocity * delta)



