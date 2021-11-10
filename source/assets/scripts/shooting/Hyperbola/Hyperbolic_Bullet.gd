extends Sprite

var velocity = Vector2()
var speed = 1
var time = 0.5
var gravitile = 5



func follow_hyperbolic_trajectory():
	velocity.x = gravitile * time
	velocity.y = 1 / time
	

func _process(delta):
	follow_hyperbolic_trajectory()
	time += delta
	position += velocity * speed * delta


func _on_hitbox_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
