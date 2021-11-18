extends Line2D

export var speed = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var time = 0
var a_parameter = -Global.get('user_input').a_param_line



func trajectory():
	while dot_position.x < 2000:
		add_point(dot_position)
		velocity.y = 10 * a_parameter
		velocity.x = 10
		dot_position += velocity * speed * 0.06944
		time += 0.06944
	pass


func _process(_delta):
	trajectory()
	update()
