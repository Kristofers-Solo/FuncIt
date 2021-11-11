extends Sprite

export(int) var damage = 25
export(int) var speed = 100
var velocity = Vector2()
var player_owner = 0

var time = 0
export var amplitude = 4
export var frequency = 5

func follow_sine_trajectory():
	velocity.y = amplitude * cos(time * frequency)
	velocity.x = 5

func _process(delta):
	follow_sine_trajectory()
	time += delta
	position += velocity * speed * delta


func _on_hitbox_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
