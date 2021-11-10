extends Area2D

export var speed = 100
var velocity = Vector2()

var time = 0
var gravitile = 5


func follow_parabolic_trajectory():
	velocity.x = 5
	velocity.y = 1 * time * gravitile


func _process(delta):
	follow_parabolic_trajectory()
	time += delta
	position += velocity * speed * delta


func _on_hitbox_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
