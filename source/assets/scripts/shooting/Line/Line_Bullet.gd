extends Area2D

export var speed = 100
var velocity = Vector2()

var time = 0


func follow_line_trajectory():
	velocity = Vector2(10, 0)

#func follow_parabolic_trajectory():
	#velocity.x = 5
	#velocity.y = 1 * time * gravitile
	#return velocity

#func follow_hyperbolic_trajectory():
	#velocity.x = gravitile * time
	#velocity.y = 1
	#return velocity
	
#func input():
	#if Input.is_action_just_pressed("line"):
		#return follow_sine_trajectory()
	#elif Input.is_action_just_pressed("sine"):
		#return follow_line_trajectory()
	#else:
		#print('Trajectory is not selected')
		#queue_free()

func _process(delta):
	follow_line_trajectory()
	time += delta
	position += velocity * speed * delta


func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
