extends Line2D

export var speed = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var time = 0
var a_parameter

func _ready():
	if Global.get("user_input") != null:
		a_parameter = -Global.get("user_input").a_param_line
	else:
		a_parameter = 0


func trajectory(delta):
	while dot_position.x < 2000:
		add_point(dot_position)
		velocity.y = 10 * a_parameter
		velocity.x = 10
		dot_position += velocity * speed * delta
		time += delta
	pass


func _process(delta):
	trajectory(delta)
	update()
