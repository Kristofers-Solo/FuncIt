extends Sprite

var velocity = Vector2()
var speed_hyper = 100
var time = 0.05
var a_parameter = 1
var b_parameter = 1



func follow_hyperbolic_trajectory():
	velocity.x = 5
	velocity.y = a_parameter/(time*b_parameter)
	

func _process(delta):
	follow_hyperbolic_trajectory()
	time += delta
	position += velocity * speed_hyper * delta


func _on_hitbox_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
