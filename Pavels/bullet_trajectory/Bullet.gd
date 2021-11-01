extends Area2D

export var speed = 100
var velocity = Vector2()
var rot = Vector2()

var time = 0
export var amplitude = 4
export var frequency = 5
var gravitile = 5


func follow_line_trajectory():
	velocity = Vector2(1, 0) #Vector2(cos(self.global_rotation), sin(self.global_rotation))
	pass

func follow_sine_trajectory():
	velocity.y = amplitude * cos(time * frequency)
	velocity.x = 5
	pass

func follow_parabolic_trajectory():
	velocity.x = 5
	velocity.y = 1 * time * gravitile
	
	
func follow_n_parabolic_trajectory():
	velocity.x = 5
	velocity.y = -1 * time * gravitile
	

func follow_hyperbolic_trajectory():
	velocity.x = gravitile * time
	velocity.y = 1
	
func follow_n_hyperbolic_trajectory():
	velocity.x = gravitile * time
	velocity.y = -1
	
	
func chosen_trajectory():
	if Input.is_action_just_pressed("line"):
		follow_line_trajectory()
	elif Input.is_action_just_pressed("parab"):
		follow_parabolic_trajectory()
	elif Input.is_action_just_pressed("n_parab"):
		follow_n_parabolic_trajectory()
	elif Input.is_action_just_pressed("hyper"):
		follow_hyperbolic_trajectory()
	elif Input.is_action_just_pressed("n_hyper"):
		follow_n_hyperbolic_trajectory()
	elif Input.is_action_just_pressed("sine"):
		follow_sine_trajectory()
	else:
		follow_line_trajectory()
		

func _process(delta):
	follow_sine_trajectory()
	time += delta
	position += velocity * speed * delta


func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
