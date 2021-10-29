extends Area2D

export var speed = 40
var velocity = Vector2()
var rot = Vector2()

var time = 0
export var amplitude = 4
export var frequency = 5


func follow_line_trajectory():
	velocity = Vector2(1, 0) #Vector2(cos(self.global_rotation), sin(self.global_rotation))
	pass

func follow_sine_trajectory():
	velocity.y = amplitude * cos(time * frequency)
	velocity.x = 5
	pass

func follow_parabolic_trajectory():
	pass
	
func follow_hyperbolic_trajectory():
	pass
	
func _process(delta):
	follow_sine_trajectory()
	time += delta
	position += velocity * speed * delta


func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
