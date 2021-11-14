extends Line2D

export var speed_hyper = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var x = 10

var time = 0.05
var a_parameter = 1
var b_parameter = 1

var pos
var angle
func _ready():
	pos = Global.get("player").get_node('weaponHolder/Player-character-theme-gun').position 
	angle = Global.get('player').get_node('weaponHolder/Player-character-theme-gun').rotation


func update_trajectory():
	clear_points()
	
	while dot_position.x < 1000:
		if pos.x > 0:
			add_point(dot_position)
			velocity.x = 10
			velocity.y = a_parameter/(time*b_parameter)
			dot_position += velocity * speed_hyper * 0.06944
			time += 0.06944
		if pos.x < 0:
			add_point(dot_position)
			velocity.x = 10
			velocity.y = a_parameter/(time*b_parameter)
			dot_position += velocity * speed_hyper * 0.06944
			time += 0.06944
			
			

func _process(delta):
	#update_trajectory()
	pass
