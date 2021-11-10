extends Line2D

var speed_parab = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var time = 0
var a_parameter = 1
var b_parameter = 0


func _draw():
	velocity.y = time*(a_parameter * time + b_parameter)
	velocity.x = 5
	dot_position += velocity * speed_parab * 0.06944
	draw_circle(dot_position, 1, Color(225, 225, 225))
	time += 0.06944

func _process(delta):
	update()
	


