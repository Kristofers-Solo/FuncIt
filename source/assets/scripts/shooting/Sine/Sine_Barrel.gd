extends Line2D


export var speed = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var time = 0
export var amplitude = 4
export var frequency = 5


func _draw():
	velocity.y = amplitude * cos(time * frequency)
	velocity.x = 5
	dot_position += velocity * speed * 0.06944
	draw_circle(dot_position, 1, Color(225, 225, 225))
	time += 0.06944

func _process(delta):
	update()
