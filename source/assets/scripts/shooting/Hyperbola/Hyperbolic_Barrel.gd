extends Line2D

export var speed_hyper = 130
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)


var time = 0.05
var a_parameter = Global.get('user_input').a_param_hyper
var b_parameter = Global.get('user_input').b_param_hyper

var pos
func _ready():
	pos = Global.get("player").get_node('weaponHolder/Player-character-theme-gun').position 
	


func trajectory(delta):
	while dot_position.x < 2000:
#		if pos.x > 0:
		add_point(dot_position)
		velocity.x = 10
		velocity.y = a_parameter/(time*b_parameter) 
		dot_position += velocity * speed_hyper * delta
		time += delta
#		if pos.x < 0:
#			add_point(dot_position)
#			velocity.x = 10
#			velocity.y = -a_parameter/(time*b_parameter) 
#			dot_position += velocity * speed_hyper * delta
#			time += delta

func _process(delta):
	trajectory(delta)
	update()
