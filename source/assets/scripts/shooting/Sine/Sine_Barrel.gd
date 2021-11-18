extends Line2D


export var speed = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var time = 0
var amplitude = Global.get('user_input').amp
var frequency = Global.get('user_input').freq


func trajectory(delta):
	while dot_position.x < 2000:
		add_point(dot_position)
		velocity.y = amplitude * cos(time * frequency)
		velocity.x = 5
		dot_position += velocity * speed * delta
		time += delta

func _process(delta):
	trajectory(delta)
	update()
